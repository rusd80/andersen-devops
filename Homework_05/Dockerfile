FROM python:3.8-slim AS compiler
WORKDIR /app
COPY /app /app 
RUN apt-get update
RUN apt-get install -y upx patchelf binutils libgcc1

RUN pip3 install pyinstaller virtualenv staticx
RUN pip freeze > requirements.txt
RUN python -m venv venv
ENV PATH $PATH:venv/bin/activate
RUN . venv/bin/activate

RUN pip3 install Flask
RUN pip3 install -r /app/requirements.txt

RUN PYTHONOPTIMIZE=1 pyinstaller --onefile --strip --paths /venv/lib/site-packages \
			-a --clean --upx-dir=/usr/bin/ app.py
RUN cat /app/app.spec
RUN staticx -l /lib/x86_64-linux-gnu/libgcc_s.so.1 --strip /app/dist/app appc

FROM scratch AS tiny
WORKDIR /
COPY --from=compiler /tmp /tmp
COPY --from=compiler /app/appc .
COPY --from=compiler /app/countries.json .
COPY --from=compiler /app/languages.json .
EXPOSE 8080
CMD ["/appc"]