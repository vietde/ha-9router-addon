# Official prebuilt image: no compiling, no npm install on your HAOS box.
# Keep this tag in sync with "version" in config.yaml.
FROM decolua/9router:0.5.95

COPY opts.js /opts.js
COPY ingress.js /ingress.js
COPY ha-start.sh /ha-start.sh
RUN chmod a+x /ha-start.sh

ENTRYPOINT ["/ha-start.sh"]
