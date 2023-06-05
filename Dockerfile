FROM gcr.io/platform-iv/mamba

# ARG INVIVOAI_ANACONDA_USER_BOT_TOKEN

# Configure the build here
ARG APP_FOLDER="/apps/app"
ARG ENV_NAME="project_env"
ARG ENV_FILE="env.yml"
ARG EXTRA_DEPS=""
ARG EXTRA_DEB_PACKAGES=""

# Set the build arg to ENV so they are available
# at runtime.
ENV APP_FOLDER=$APP_FOLDER
ENV ENV_NAME=$ENV_NAME
ENV ENV_FILE=$ENV_FILE
ENV EXTRA_DEPS=$EXTRA_DEPS
ENV EXTRA_DEB_PACKAGES=$EXTRA_DEB_PACKAGES

# Install extra .deb packages if any
USER root
RUN if [ -n "${EXTRA_DEB_PACKAGES}" ]; then \
    apt update --fix-missing && apt install --no-install-recommends -y ${EXTRA_DEB_PACKAGES} \
    && apt clean; fi
USER $MAMBA_USER

# Copy env.yml file
COPY --chown=$MAMBA_USER:$MAMBA_USER ./$ENV_FILE /tmp/$ENV_FILE

# Mamba authentication is only needed if a private mamba channel is required.
# Otherwise, this RUN statement can be commented out.
# RUN micromamba auth login conda.anaconda.org --token $INVIVOAI_ANACONDA_USER_BOT_TOKEN

# Install the app specific mamba env
RUN if [ ! -z "${NVIDIA_VISIBLE_DEVICES}" ]; then export PYTORCH_GPU="pytorch-gpu" ; fi && \
    micromamba create --yes --name $ENV_NAME -f /tmp/$ENV_FILE $EXTRA_DEPS $PYTORCH_GPU && \
    micromamba clean --all --yes

# Activate the new mamba env
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Install the git version of QCFractal
# commit if from `next` branch at the date of 01/05/2023
RUN pip install --no-deps git+https://github.com/MolSSI/QCFractal.git@c00627258f9344b4b35a7583ee4a9cc5ff2de3e8#subdirectory=qcportal
RUN pip install --no-deps git+https://github.com/MolSSI/QCFractal.git@c00627258f9344b4b35a7583ee4a9cc5ff2de3e8#subdirectory=qcfractalcompute
RUN pip install --no-deps git+https://github.com/MolSSI/QCFractal.git@c00627258f9344b4b35a7583ee4a9cc5ff2de3e8#subdirectory=qcfractal

# Copy the entire app git repo to the container
COPY --chown=$MAMBA_USER:$MAMBA_USER . $APP_FOLDER

# Install the project application with `pip`
RUN pip install -e $APP_FOLDER

CMD ["/apps/app/docker/entrypoint.sh"]
