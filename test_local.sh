#!/bin/bash  
echo "Testando Cofre Digital Localmente..." 

echo "Construindo container image..."  
docker build -f docker/Dockerfile -t cofre-digital-local . 

echo "Iniciando aplicação com secrets de dev..."  
docker run -d --name cofre-test \
  -p 5000:5000 \
  -e ENVIRONMENT=test \
  -e DB_HOST=test-db.local \
  -e DB_USER=test_user \
  -e DB_PASSWORD=test_password_123 \
  -e EXTERNAL_API_KEY=test_key_abcd1234 \
  cofre-digital-local  

sleep 5

echo "Testando endpoints..." 
curl -s http://localhost:5000/
echo ""
curl -s http://localhost:5000/database
echo ""
curl -s http://localhost:5000/api-key
echo ""

echo "Verificando logs (secrets devem estar mascarados)..." 
docker logs cofre-test 

echo "Limpeza..." 
docker stop cofre-test 
docker rm cofre-test  
echo "Teste local concluído!"

