FROM python:3.8-slim AS compiler

WORKDIR /app
COPY /app /app

RUN apt-get update \
&& apt-get install -y upx patchelf binutils libgcc1 \
&& pip3 install pyinstaller virtualenv staticx \
&& pip freeze > requirements.txt \
&& python -m venv venv

# virtualenv is needed by pyinstaller
ENV PATH $PATH:venv/bin/activate

RUN . venv/bin/activate
RUN pip3 install Flask
RUN pip3 install -r /app/requirements.txt

# pyinstaller optimizes our flask app
RUN PYTHONOPTIMIZE=1 pyinstaller --onefile --strip --paths /venv/lib/site-packages \
			-a --clean --upx-dir=/usr/bin/ app.py \
# staticx converts app to static binary that can be run on Scratch image \
# also libgcc library is needed for on scratch
&& staticx -l /lib/x86_64-linux-gnu/libgcc_s.so.1 --strip /app/dist/app appc

RUN mkdir /app/tmp

FROM scratch AS tiny

COPY --from=compiler /app/tmp /tmp
COPY --from=compiler /app/appc .
COPY --from=compiler /app/countries.json .
COPY --from=compiler /app/languages.json .
EXPOSE 8080
CMD ["/appc"]