FROM ruby:3.1.2

ARG DEV_USERNAME
ARG DEV_UID
ARG DEV_GID

# Create the user
RUN groupadd --gid $DEV_GID $DEV_USERNAME \
    && useradd --uid $DEV_UID --gid $DEV_GID -m $DEV_USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $DEV_USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$DEV_USERNAME \
    && chmod 0440 /etc/sudoers.d/$DEV_USERNAME

USER $DEV_USERNAME

RUN sudo apt-get update -y && sudo apt-get upgrade -y
RUN gem install bundler jekyll

CMD [ "/bin/bash" ]
