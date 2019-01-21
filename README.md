# Cliente Ruby para emissão de notas fiscais - NFe.io

## Onde acessar a documentação da API?

> Acesse a [nossa documentação](https://nfe.io/doc/rest-api/nfe-v1) para mais detalhes e referências.

## Como realizar a instalação do pacote?

Para executar a instalação do nosso pacote, você deverá incluir essa linha no Gemfile da sua aplicação:

```ruby
gem 'nfe-io'
```

E depois executar:

    $ bundle

Ou se preferir, instale diretamente via comando:

    $ gem install nfe-io

## Exemplos de uso

> Em construção!

### Como emitir uma Nota Fiscal de Serviço?
Abaixo, temos um código-exemplo para realizar uma Emissão de Nota Fiscal de Serviço:

```ruby
# Define a API Key, conforme está no painel
Nfe.api_key('c73d49f9649046eeba36dcf69f6334fd')

# ID da empresa, você encontra no painel
Nfe::ServiceInvoice.company_id("55df4dc6b6cd9007e4f13ee8")

# Dados do Tomador dos Serviços
customer_params = {
  borrower: {
    federalTaxNumber: '191', # CNPJ ou CPF (opcional para tomadores no exterior)
    name: 'BANCO DO BRASIL SA', # Nome da pessoa física ou Razão Social da Empresa
    email: 'nfe-io@mailinator.com', # Email para onde deverá ser enviado a nota fiscal
    # Endereço do tomador
    address: {
      country: 'BRA', # Código do pais com três letras
      postalCode: '70073901', # CEP do endereço (opcional para tomadores no exterior)
      street: 'Rua Do Cliente', # Logradouro
      number: 'S/N', # Número (opcional)
      additionalInformation: 'QUADRA 01 BLOCO G', # Complemento (opcional)
      district: 'Asa Sul', # Bairro
      city: { # Cidade é opcional para tomadores no exterior
        code: 4204202, # Código do IBGE para a Cidade
        name: 'Brasilia' # Nome da Cidade
      },
      state: 'DF'
    }
  }
}

# Dados da nota fiscal de serviço
service_params = {
  cityServiceCode: '2690', # Código do serviço de acordo com o a cidade
  description: 'Teste, para manutenção e suporte técnico.', # Descrição dos serviços prestados
  servicesAmount: 0.1 # Valor total do serviços
}

# Emite a nota fiscal
invoice_create_result = Nfe::ServiceInvoice.create(customer_params.merge(service_params))
```

### Como cancelar uma nota?
Abaixo, temos um código-exemplo para efetuar o cancelamento de uma nota: 

```ruby
# Define a API Key, conforme está no painel
Nfe.api_key('c73d49f9649046eeba36dcf69f6334fd')
# ID da empresa, você encontra no painel
Nfe::ServiceInvoice.company_id("55df4dc6b6cd9007e4f13ee8")
# O parâmetro é o ID da nota
invoice = Nfe::ServiceInvoice.cancel("59443a0e2a8b6806986d7a2d")
# A resposta são os dados da nota com a mudança de estado para "WaitingSendCancel"
```

### Criar uma Empresa para Emissão de Notas
>Em construção!

### Como efetuar o download de uma nota em PDF?
Abaixo, temos um código exemplo para baixar uma nota em PDF:

```ruby
# Define a API Key, conforme está no painel
Nfe.api_key('c73d49f9649046eeba36dcf69f6334fd')
# ID da empresa, você encontra no painel
Nfe::ServiceInvoice.company_id("55df4dc6b6cd9007e4f13ee8")
# Os formatos suportados são :pdf e :xml, e o primeiro parâmetro é o ID da nota
invoice = Nfe::ServiceInvoice.download("59443a0e2a8b6806986d7a2d", :pdf)
# O conteúdo do PDF/XML pode ser acessado da seguinte forma
invoice.body
# Caso você esteja utilizando Rails, pode usar o método send_data para retornar
# o conteúdo da Nota Fiscal diretamente para o usuário
# Note que neste caso o arquivo é o PDF, mas poderia ser o XML, mude se necessário
send_data(invoice.body, filename: 'invoice.pdf', type: 'application/pdf')
```

### Como validar o Webhook?
```ruby
def request_is_authentic?
  body = request.body.read
  signature = request.headers['X-NFEIO-Signature']

  hash = 'sha1=' + Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), ENV.fetch("NFEIO_WEBHOOK_SECRET"), body))

  ActiveSupport::SecurityUtils.secure_compare(hash, signature)
end
```
