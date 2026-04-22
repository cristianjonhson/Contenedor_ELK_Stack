# Contenedor ELK Stack

Proyecto simple para levantar un entorno local de **ELK Stack** usando Docker.

ELK Stack está compuesto por:

- **Elasticsearch**: motor de búsqueda y almacenamiento de logs.
- **Logstash**: procesamiento y envío de logs.
- **Kibana**: interfaz web para visualizar la información.

## Tecnologías utilizadas

- Docker
- Docker Compose
- Elasticsearch
- Logstash
- Kibana

## Estructura del proyecto

```text
Contenedor_ELK_Stack/
├── Dockerfile
├── docker-compose.yml
├── .env
├── README.md
└── logstash/
    ├── config/
    │   └── logstash.yml
    └── pipeline/
        └── logstash.conf
````

## Requisitos previos

Tener instalado:

* Docker
* Docker Compose
* Git

Para verificar:

```bash
docker --version
docker compose version
git --version
```

## Levantar el proyecto

Desde la raíz del proyecto ejecutar:

```bash
docker compose up -d --build
```

## Verificar contenedores

```bash
docker ps
```

Deberías ver contenedores para:

* Elasticsearch
* Logstash
* Kibana

## Accesos

Elasticsearch:

```text
http://localhost:9200
```

Kibana:

```text
http://localhost:5601
```

Logstash TCP:

```text
localhost:5000
```

Logstash Beats:

```text
localhost:5044
```

## Probar envío de logs

Puedes enviar un log de prueba con:

```bash
echo '{"message":"Hola desde Logstash","level":"INFO","app":"demo-elk"}' | nc localhost 5000
```

Luego entra a Kibana y busca el índice:

```text
logs-*
```

## Configuración de Kibana y Enrollment Token

Al iniciar Kibana por primera vez, puede aparecer una pantalla solicitando un **Enrollment Token** con el mensaje:

```text
Configure Elastic to get started
Enrollment token
Enter an enrollment token.
````

Este token se utiliza cuando Elasticsearch tiene la seguridad habilitada mediante `xpack.security.enabled=true`. Sin embargo, este proyecto está configurado para ejecutarse como laboratorio local, por lo que la seguridad de Elasticsearch está deshabilitada:

```yaml
xpack.security.enabled=false
```

Por esta razón, Kibana no debería requerir un enrollment token. Para evitar esa pantalla, el servicio de Kibana se configura directamente para conectarse a Elasticsearch mediante la variable de entorno:

```yaml
kibana:
  image: docker.elastic.co/kibana/kibana:${ELASTIC_VERSION}
  container_name: kibana
  environment:
    - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    - XPACK_SECURITY_ENABLED=false
  ports:
    - "5601:5601"
  networks:
    - elk
  depends_on:
    - elasticsearch
```

Si Kibana sigue solicitando el token, es posible que haya quedado una configuración previa almacenada en los volúmenes de Docker. En ese caso, se recomienda reiniciar el stack eliminando los volúmenes:

```bash
docker compose down -v
docker compose up -d --build
```

Luego se puede validar que Elasticsearch esté respondiendo correctamente con:

```bash
curl http://localhost:9200
```

Y acceder a Kibana desde el navegador:

```text
http://localhost:5601
```

> Nota: Esta configuración es recomendada solo para entornos locales o de laboratorio. Para producción se debe habilitar seguridad, autenticación, certificados TLS y credenciales de acceso.

## Detener el proyecto

```bash
docker compose down
```

## Eliminar contenedores y volúmenes

```bash
docker compose down -v
```

## Subir cambios a GitHub

```bash
git add .
git commit -m "Add README"
git push -u origin main
```

## Nota

Este proyecto está pensado para uso local y aprendizaje.
La seguridad de Elasticsearch está desactivada para simplificar el laboratorio.

No se recomienda usar esta configuración directamente en producción.

````

Luego guarda con:

```bash
CTRL + O
Enter
CTRL + X
````

Y súbelo:

```bash
git add README.md
git commit -m "Add simple README"
git push -u origin main
```
