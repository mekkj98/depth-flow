import runpod
from DepthFlow.Scene import DepthScene
from DepthFlow.Motion import Animation, Components, Preset, Presets, Target

import base64
import os

# Supported Animations and Their Parameters:
# Vertical:
#   - intensity: float (default: 1.0)
#   - reverse: bool (default: False)
#   - smooth: bool (default: True)
#   - loop: bool (default: True)
#   - phase: float (default: 0.0)
#   - steady: float (default: 0.3)
#   - isometric: float (default: 0.6)
# Horizontal:
#   - intensity: float (default: 1.0)
#   - reverse: bool (default: False)
#   - smooth: bool (default: True)
#   - loop: bool (default: True)
#   - phase: float (default: 0.0)
#   - steady: float (default: 0.3)
#   - isometric: float (default: 0.6)
# Zoom:
#   - intensity: float (default: 1.0)
#   - reverse: bool (default: False)
#   - smooth: bool (default: True)
#   - loop: bool (default: True)
#   - phase: float (default: 0.0)
# Circle:
#   - amplitude: tuple(float, float, float) (default: (1.0, 1.0, 0.0))
#   - smooth: bool (default: True)
#   - phase: tuple(float, float, float) (default: (0.0, 0.0, 0.0))
#   - steady: float (default: 0.3)
#   - isometric: float (default: 0.6)
# Dolly:
#   - intensity: float (default: 1.0)
#   - reverse: bool (default: False)
#   - smooth: bool (default: True)
#   - loop: bool (default: True)
#   - depth: float (default: 0.5)
#   - phase: float (default: 0.0)
# Orbital:
#   - depth: float (default: 0.0)


def handler(event):
    input = event['input']
    image = input.get('image')

    fps = input.get('fps', 30)
    time = input.get('time', 5)

    # Animation parameters
    animation_type = input.get('animation_type', 'dolly')
    animation_params = input.get('animation_params', {})

    # Create a DepthScene instance
    scene = DepthScene()

    # Dynamically add the specified animation
    if hasattr(Presets, animation_type.capitalize()):
        animation_class = getattr(Presets, animation_type.capitalize())
        animation = animation_class(**animation_params)
        scene.animation.add(animation)
    else:
        raise ValueError(f"Invalid animation type: {animation_type}")

    # Provide the image input
    scene.input(image=image)

    # Set the output path
    output_path = "video.mp4"

    # Run DepthFlow main method
    scene.main(output=output_path, fps=fps, time=time)

    # Read the video file and convert to base64
    with open(output_path, "rb") as video_file:
        video_base64 = base64.b64encode(video_file.read()).decode('utf-8')

    # Delete the video file
    os.remove(output_path)

    return {
        "video_base64": video_base64
    }

if __name__ == '__main__':
    runpod.serverless.start({'handler': handler})