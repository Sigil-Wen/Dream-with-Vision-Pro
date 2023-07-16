# Dream with Vision Pro

[![Discord](https://img.shields.io/discord/1126234207044247622)](https://discord.gg/C6ukDBEbFY)

Welcome to Dream with Vision Pro, a lucid text-to-3D tool built with the Apple VisionOS SDK. Powered by Scale AI's Spellbook, OpenAI's GPT-4 and Shap-E, Modal, Replicate, and the Meta Quest 2, we empower you to transform your imagination into stunning immersive experiences.

<h2 align="center"><b>Demo</b></h2>

##  Enter Your Vision:

Type in the text description of the object you envision. This could be anything from an elephant to a sword. Unleash your imagination. Once you've described it, your object will appear before you.

## How it Works
Here's a step-by-step breakdown of what Dream with Vision Pro does:

First, the user specifies the object they want to visualize. This input triggers the Shap-E model via Modal and Replicate, producing a .obj file - a standard 3D model format.

Once we have the .obj file, we call a Modal endpoint which lets us convert to the .usdz format - the format VisionOS uses.

Next, we employ Spellbook and GPT-4 to estimate the object's height, ensuring the 3D representation is accurately scaled.

The final step utilizes VisionOS to render your object into a realistic 3D model. This 3D model is then streamed directly to your Meta Quest 2, providing an immersive experience of your original idea.

## Next Steps

We've started to integrate OpenAI's Whisper model, expanding our capability beyond text-to-3D transformations. Users will be able to engage in a more intuitive way, interacting with their 3D creations through the power of voice.
