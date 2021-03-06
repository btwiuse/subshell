FROM btwiuse/k0s AS k0s

FROM btwiuse/dkg AS dkg

FROM denoland/deno:debian AS deno

# dkg push -i btwiuse/subshell:bin -f subshell
FROM btwiuse/subshell:bin AS subshell-bin

FROM node

ENV RUNNING_IN_DOCKER=1

RUN apt update

RUN apt install -y jq vim bash tmux htop neofetch figlet sudo

COPY --from=k0s /usr/bin/k0s /bin/hub
COPY --from=dkg /bin/dkg /bin
COPY --from=deno /usr/bin/deno /bin
# COPY --from=subshell-bin --chmod=777 /subshell /bin
COPY --from=subshell-bin /subshell /bin

RUN chmod a+rx /bin/subshell

RUN ln -sf /bin/hub /bin/agent

# RUN apk add nodejs-current npm yarn jq vim bash tmux htop neofetch

ADD subsh-deno /bin/

COPY *.ts .
COPY package.json .

ENV DENO_DIR=/cache

RUN subsh-deno cache

RUN useradd -N subshell

RUN chown -R subshell /cache

COPY deno_history.txt /cache/
RUN chown root:root /cache/deno_history.txt
RUN chmod 644 /cache/deno_history.txt

USER subshell

ENTRYPOINT ["bash", "-c"]

CMD ["hub --port :${PORT:-8000}"]
