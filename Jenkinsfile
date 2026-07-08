pipeline {
    agent any

    stages {

        stage("1. Clonar repositorio") {
            steps {
                echo '..Conectando con Github y descargando el repositorio'
                git url: 'https://github.com/Gustavo4681501/OA_Laboratorio_1.git', branch: 'main'
            }
        }

        stage("2. Detener contenedores previos") {
            steps {
                echo '...Limpiando residuos del host'
                sh 'docker compose down || true'
            }
        }

        stage("3. Desplegar en producción") {
            steps {
                echo '...Levantando WordPress y MySQL'
                sh 'docker compose up -d --build'
            }
        }

        stage("4. Configurar conexión a la base de datos") {
            steps {
                echo '...Esperando MySQL y configurando wp-config.php'
                sh '''
                until docker exec wp_mysql mysqladmin ping -h localhost -u root -p"$MYSQL_ROOT_PASSWORD" --silent; do
                  echo "Esperando a MySQL..."
                  sleep 3
                done

                # Generar wp-config.php dentro del contenedor de WordPress usando wp-cli
                docker exec wp_laboratorio bash -c "
                  if [ ! -f wp-config.php ]; then
                    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&
                    chmod +x wp-cli.phar &&
                    mv wp-cli.phar /usr/local/bin/wp
                    wp config create \
                      --dbname=$MYSQL_DATABASE \
                      --dbuser=$MYSQL_USER \
                      --dbpass=$MYSQL_PASSWORD \
                      --dbhost=db:3306 \
                      --allow-root
                  fi
                "
                '''
            }
        }

        stage('5. Verificar el sitio') {
            steps {
                echo 'Validando contenedores y sitio web'
                sh 'docker ps'
                sh 'docker network ls'
                sh 'docker volume ls'
                sleep 20
                sh 'curl -I http://wp_laboratorio:80/'
            }
        }
    }

    post {
        success {
            echo 'Despliegue completado correctamente. WordPress disponible en http://localhost:8081'
        }
        failure {
            echo 'El pipeline falló. Revisar logs de Jenkins.'
        }
    }
}