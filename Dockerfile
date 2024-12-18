# ------------------------------------------------------------------------------------------------ #
# (c) MIT License, Tremeschin
# Dockerfile v2024.12.4
# ------------------------------------------------------------------------------------------------ #
# General metadata and configuration

ARG BASE_IMAGE="ubuntu:24.04"
FROM ${BASE_IMAGE}
ENV DEBIAN_FRONTEND="noninteractive"
ARG WORKDIR="/App"
RUN apt update
WORKDIR "${WORKDIR}"

# ------------------------------------------------------------------------------------------------ #
# Make Vulkan and OpenGL EGL acceleration work on NVIDIA (the unveiled magic of nvidia/glvnd)

# Nvidia container toolkit configuration
ENV NVIDIA_DRIVER_CAPABILITIES="all"
ENV NVIDIA_VISIBLE_DEVICES="all"

# Don't use llvmpipe (software rendering) on WSL
ENV MESA_D3D12_DEFAULT_ADAPTER_NAME="NVIDIA"
ENV LD_LIBRARY_PATH="/usr/lib/wsl/lib"

# (ShaderFlow) Don't use glfw
ENV WINDOW_BACKEND="headless"

# Add libEGL ICD loader and libraries
RUN apt install -y libglvnd0 libglvnd-dev libegl1-mesa-dev && \
    mkdir -p /usr/share/glvnd/egl_vendor.d && \
    echo '{"file_format_version":"1.0.0","ICD":{"library_path":"libEGL_nvidia.so.0"}}' > \
    /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# Add Vulkan ICD and libraries
RUN apt install -y libvulkan1 libvulkan-dev && \
    mkdir -p /usr/share/vulkan/icd.d && \
    echo '{"file_format_version":"1.0.0","ICD":{"library_path":"libGLX_nvidia.so.0","api_version":"1.3"}}' > \
    /usr/share/vulkan/icd.d/nvidia_icd.json

RUN apt install -y xorg-dev libglu1-mesa-dev

# ------------------------------------------------------------------------------------------------ #


# Video encoding and decoding
RUN apt install -y xz-utils curl
ARG FFMPEG="ffmpeg-master-latest-linux64-gpl"
RUN curl -L "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/${FFMPEG}.tar.xz" | \
    tar -xJ --strip-components=2 --exclude="doc" --exclude="man" -C /usr/local/bin


# Cache depth estimator models
RUN pip install huggingface-hub

RUN huggingface-cli download "depth-anything/Depth-Anything-V2-small-hf" && \
    huggingface-cli download "depth-anything/Depth-Anything-V2-base-hf"

# Install a PyTorch flavor
ARG TORCH_VERSION="2.5.1"
ARG TORCH_FLAVOR="cpu"
RUN pip install torch=="${TORCH_VERSION}+${TORCH_FLAVOR}" \
    --index-url "https://download.pytorch.org/whl/${TORCH_FLAVOR}"
RUN pip install transformers
RUN pip install runpod
RUN pip install depthflow

# ------------------------------------------------------------------------------------------------ #


COPY depthflow.py /depthflow.py

CMD ["python3", "/depthflow.py"]
