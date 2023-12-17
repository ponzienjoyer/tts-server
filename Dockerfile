# Use an official Python runtime as a parent image with CUDA support
FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-pip python3-dev \
        espeak git build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install Python dependencies
RUN pip install phonemizer torch torchaudio

# Install TTS-Server from the repository
RUN pip install git+https://github.com/lxe/tts-server.git

RUN python3 -m nltk.downloader punkt

# Make port 5050 available to the world outside this container
EXPOSE 5050

# Run tts_server.server when the container launches
CMD ["python3", "-m", "tts_server.server"]
