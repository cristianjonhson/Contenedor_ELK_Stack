# Contenedor ELK Stack

Stack local de observabilidad con Elasticsearch, Logstash y Kibana (ELK) ejecutado con Docker Compose.

El objetivo de este repositorio es ofrecer un entorno rápido para desarrollo, pruebas y aprendizaje de ingestión de logs en Elasticsearch, usando Logstash como pipeline de entrada y Kibana para visualización.

## Descripción Del Proyecto

Este proyecto levanta 3 servicios:

- Elasticsearch: almacenamiento e indexación de eventos.
- Logstash: recepción de logs por TCP/Beats y envío a Elasticsearch.
- Kibana: exploración y visualización de datos.

La configuración está pensada para laboratorio local:

- Nodo único de Elasticsearch.
- Seguridad desactivada (`xpack.security.enabled=false`).
- Volumen persistente para datos de Elasticsearch.

## Tecnologías

- Docker
- Docker Compose
- Elasticsearch
- Logstash
- Kibana

## Estructura Del Repositorio

```text
Contenedor_ELK_Stack/
├── .env
├── Dockerfile
├── docker-compose.yml
├── README.md
└── logstash/
    ├── config/
    │   └── logstash.yml
    └── pipeline/
        └── logstash.conf
```

## Requisitos

- Docker Engine 20+
- Docker Compose v2+
- Git (opcional, para clonar/versionar)
- `curl` y `nc` (opcional, para pruebas rápidas)

Verificación:

```bash
docker --version
docker compose version
git --version
```

## Configuración

### Variables De Entorno

El archivo `.env` define la versión del stack Elastic usada en `docker-compose.yml`:

```env
ELASTIC_VERSION=9.3.4
```

Notas:

- `docker-compose.yml` utiliza `${ELASTIC_VERSION}` para Elasticsearch y Kibana.
- `Dockerfile` de Logstash también recibe `ELASTIC_VERSION` como build-arg.

### Puertos Expuestos

- `9200`: Elasticsearch HTTP API.
- `9300`: transporte interno de Elasticsearch.
- `5601`: Kibana.
- `5050`: entrada TCP de Logstash (mapeada al puerto interno `5000`).
- `5044`: entrada Beats de Logstash.
- `9600`: API HTTP de Logstash.

## Cómo Ejecutarlo

Desde la raíz del proyecto:

```bash
docker compose up -d --build
```

Verificar estado:

```bash
docker compose ps
```

## Validación Rápida

### 1) Validar Elasticsearch

```bash
curl http://localhost:9200
```

### 2) Validar Kibana

Abrir en navegador:

```text
http://localhost:5601
```

### 3) Enviar Un Log De Prueba A Logstash (TCP)

```bash
echo '{"message":"Hola desde Logstash","level":"INFO","app":"demo-elk"}' | nc localhost 5050
```

### 4) Consultar Índices En Elasticsearch

```bash
curl "http://localhost:9200/_cat/indices?v"
```

Deberías ver índices con prefijo `logs-`.

## Pipeline De Logstash

Configuración actual en `logstash/pipeline/logstash.conf`:

- Inputs:
  - `tcp` en puerto `5000` con codec `json`.
  - `beats` en puerto `5044`.
- Filter:
  - sin transformaciones por defecto.
- Output:
  - Elasticsearch en `http://elasticsearch:9200`.
  - Índice `logs-%{+YYYY.MM.dd}`.
  - Salida adicional por consola (`stdout` con `rubydebug`).

## Operaciones Comunes

Detener servicios:

```bash
docker compose down
```

Detener y eliminar volúmenes (limpieza total):

```bash
docker compose down -v
```

Ver logs de un servicio:

```bash
docker compose logs -f logstash
docker compose logs -f elasticsearch
docker compose logs -f kibana
```

## Solución De Problemas

### Kibana solicita configuración inicial o token

Este proyecto desactiva seguridad para entorno local, por lo que no debería requerir enrollment token.

Si aparece la pantalla de setup:

1. Reinicia completamente los contenedores y volúmenes.
2. Levanta de nuevo el stack.

```bash
docker compose down -v
docker compose up -d --build
```

### No aparece índice `logs-*`

Revisar:

1. Que el evento se esté enviando al puerto host `5050`.
2. Logs de Logstash para confirmar recepción/parsing.
3. Estado de Elasticsearch.

## Seguridad Y Alcance

Configuración orientada a desarrollo local y aprendizaje:

- Sin autenticación.
- Sin TLS.
- Sin hardening de red.

No usar esta configuración en producción sin controles de seguridad adicionales.
