from cog import BasePredictor, Input, Path
from DepthFlow import DepthScene

class Predictor(BasePredictor):
    def setup(self):
        """
        If you need to load model weights or do any heavy lifting,
        you can do it here. For DepthFlow, it might not be necessary,
        but if you had a separate model, this is where you'd load it.
        """
        pass

    def predict(
        self,
        image: str = Input(description="URL or file path to the input image"),
        intensity: float = Input(description="Dolly intensity", default=1.5),
        reverse: bool = Input(description="Reverse dolly direction", default=False),
        fps: int = Input(description="Frames per second for output video", default=30),
        time: float = Input(description="Duration of output video in seconds", default=5),
    ) -> Path:
        """
        Runs DepthFlow on the given image with specified parameters to produce a video.
        """
        
        # Create a DepthScene instance
        scene = DepthScene()
        
        # Set dolly parameters
        scene.dolly(intensity=intensity, reverse=reverse)
        
        # Provide the image input
        scene.input(image=image)
        
        # Set the output path
        output_path = "video.mp4"
        
        # Run DepthFlow main method
        scene.main(output=output_path, fps=fps, time=time)
        
        # Return the path to the generated video
        return Path(output_path) 