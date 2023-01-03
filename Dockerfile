FROM python:3.10
ADD requirements.txt .
RUN pip install --require-hashes -r requirements.txt
RUN pip install -e git+https://github.com/google/ads-api-report-fetcher.git#egg=google-ads-api-report-fetcher\&subdirectory=py
ADD google_ads_queries/ google_ads_queries/
ADD bq_queries/ bq_queries/
ADD scripts/ .
ADD google-ads.yaml .
ADD config.yaml .
ADD main.py .
RUN chmod a+x run-docker.sh
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
