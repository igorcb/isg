# Teste Back End INFORMA ISG

## Objetivo

O objetivo deste teste é avaliar sua capacidade em criar um projeto de API do Rails com as funcionalidades básicas de CRUD, autenticação e associações entre modelos. Você deverá criar rotas para cada um dos CRUD's para cada modelo, incluindo uma rota de autenticação para permitir que os usuários se autentiquem antes de acessar as rotas protegidas.

Os modelos que você deverá implementar, bem como suas respectivas colunas, são:

### Usuário (id, nome, email, senha)
### Post (id, titulo, texto, usuário[associação])
### Comentário (id, nome, comentário, post[associação])

Deve conter uma rota de autenticação, e a rota de criação/edição/exclusão de post e usuário devem estar bloqueadas.
Além disso, você deve preferencialmente escrever testes para as rotas criadas para garantir que a API esteja funcionando corretamente. É recomendado usar alguma biblioteca para padronizar as respostas, como o Jbuilder, que permite formatar as respostas em JSON de acordo com as especificações do projeto.

## Ferramentas Utilizadas

Ruby: 3.2.1

Rails: 7.0.5

Rspec: 6.0.3

Factory Bot Rails: 6.2.0

JWT: 2.7.1

bcrypt: 3.1.18

Simplecov: 0.22.0

## Running the project

Certifique-se que está instalado o ruby e o ruby on rails em sua máquina

Em seguida clone o projeto

```bash
git clone https://github.com/igorcb/isg.git
```

Criar o banco de dados e suas tabelas

```bash
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

Rodas os testes automatizados

```bash
bundle exec rspec spec/
```

Rodas o servidor

```bash
bundle exec rails s -b 0.0.0.0 -p 3000 
```

Agora vc pode fazer requisições da API ferramenta cliente de API REST
como **Postman** ou **Insomnia**

Exemplo: #login
url: <http://localhost:3000/login> escolha o método "post"
body json: {"email": "<admin@example.com>", "password": "123456"}

essa endpoint vai retornar um token, copie.

url: <http://localhost:3000/users> escolha o método "get"
Authenticated: Baerer Toke, cole o token copiado
