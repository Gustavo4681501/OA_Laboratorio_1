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

        stage("4. Verificar el sitio") {
            steps {
                echo 'Validando contenedores y sitio web'
                sh 'docker ps'
                sh 'docker network ls'
                sh 'docker volume ls'
                sleep 5
                sh 'curl -I http://localhost:8081/'
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