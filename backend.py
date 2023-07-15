import json
import time
import modal

from fastapi import FastAPI, UploadFile, File, HTTPException, Request, Form
from fastapi.middleware.cors import CORSMiddleware

from modal import Image, Stub, asgi_app

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

stub = Stub("dream")
image = Image.debian_slim().pip_install(
    "requests", 
    "replicate",
    "openai", 
)
        
@app.get("/")
def root():
    return {"hello": "world"}

@app.post("/predictions/{prompt}")
async def create_and_get_prediction(prompt: str):
    headers = {
        "Authorization": f"Token REPLICATE_API_TOKEN",
        "Content-Type": "application/json"
    }
    print("in predictions with prompt and headers", prompt, headers)
    
    response = requests.post(
        "https://api.replicate.com/v1/deployments/replicate/shap-e-test/predictions",
        headers=headers,
        data=json.dumps({"input": {"prompt": prompt, "save_mesh": True}})
    )
    print("response from prediction creation", response.json())
        
    output = ""
    prediction_id = response.json()['id']
    start_time = time.time()
    
    while True:
        print('trying for seconds:', time.time() - start_time)
        response = requests.get(
            f"https://api.replicate.com/v1/predictions/{prediction_id}",
            headers=headers
        )
        if response.status_code != 200:
            raise HTTPException(status_code=400, detail="Failed to get prediction")
        
        if response.json().get('status') == 'succeeded':
            output = response.json().get('output')[1]
            break

        if time.time() - start_time > 30:  # break after 30 seconds
            break

        time.sleep(5)  # wait for 5 seconds before the next request

    if response.status_code != 200:
        raise HTTPException(status_code=400, detail="Failed to get prediction")
    
    return output
    

@stub.function(image=image, gpu="any", secrets=[
    modal.Secret.from_name("openai-api-key"),
])

@asgi_app()
def fastapi_app():
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    return app

if __name__ == "__main__":
    stub.deploy("webapp")

