# ProcessMaker Community Edition

**ProcessMaker-CE** latest version, docker image based on **Nginx**, **PHP-FPM**

---

## Example

You can run this image using `docker run` command:

```bash
docker run --rm -it -p 8000:80 -e URL=localhost:8000 koliber/processmaker
```

Or you can run by `docker-compose`:

```yml
version: "3.5"
services:
    database:
        image: mysql:5.6
        command: --default-authentication-plugin=mysql_native_password --lower_case_table_names=1 --character-set-server=utf8 --collation-server=utf8_general_ci
        environment:
            MYSQL_ROOT_PASSWORD: root
        restart: always
    processmaker:
        image: koliber/processmaker
        ports:
            - 8000:80
        environment:
            URL: localhost:11002
        restart: always
        depends_on:
            - database
```

---

## Contributions

-   [KoLiBer](https://www.linkedin.com/in/mohammad-hosein-nemati-665b1813b/)

## License

This project is licensed under the [MIT license](LICENSE.md).
Copyright (c) KoLiBer (koliberr136a1@gmail.com)
