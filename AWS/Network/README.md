# 🌐 Terraform AWS Network Infrastructure

## 📋 Visão Geral

Este projeto Terraform automatiza o provisionamento de uma infraestrutura de rede robusta e escalável na AWS, seguindo as melhores práticas de DevOps e Infraestrutura como Código (IaC).

## ✨ Recursos Principais

- **Modularidade:** Arquitetura baseada em módulos reutilizáveis
- **Multi-ambiente:** Suporte para desenvolvimento, staging e produção
- **Segurança:** Configurações de segurança padronizadas
- **Escalabilidade:** Projetado para crescimento e adaptação

## 🏗️ Arquitetura da Infraestrutura

### Componentes de Rede

- **VPC:** Rede virtual isolada
- **Subredes:** Públicas e privadas em múltiplas zonas de disponibilidade
- **Internet Gateway:** Conectividade com a internet
- **NAT Gateway:** Acesso à internet para recursos em sub-redes privadas
- **Grupos de Segurança:** Controle de tráfego de rede
- **Tabelas de Roteamento:** Direcionamento de tráfego

## 📦 Estrutura do Projeto

```
terraform-aws-network/
│
├── main.tf                 # Configuração principal
├── variables.tf            # Definições de variáveis
├── outputs.tf              # Saídas do Terraform
├── backend.tf              # Configuração de backend
│
├── environments/           # Configurações específicas por ambiente
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── prod.tfvars
│
└── modules/                # Módulos reutilizáveis
├── vpc/
├── subnets/
├── internet_gateway/
├── nat_gateway/
├── route_tables/
└── security_groups/
```

## 🛠️ Pré-requisitos

- Terraform `>= 1.0.0`
- AWS CLI
- Credenciais AWS configuradas
- Conta AWS com permissões adequadas

## 🚀 Instalação e Configuração

### 1. Configurar Backend S3

```bash
# Criar bucket S3 para armazenamento de estado
aws s3 mb s3://platform-terraform-state --region ${AWS_REGION}

# Criar tabela DynamoDB para locking
aws dynamodb create-table \
    --table-name platform-terraform-state \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```
### 2. Inicializar Terraform
```bash
terraform init
```

### 3. Criar Workspaces
```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```
## 🔧 Utilização
### Planejar Infraestrutura
```bash
# Ambiente de desenvolvimento
terraform plan -var-file=environments/dev.tfvars

# Ambiente de produção
terraform plan -var-file=environments/prod.tfvars
```
### Aplicar Configuração
```bash
# Ambiente de desenvolvimento
terraform apply -var-file=environments/dev.tfvars

# Ambiente de produção
terraform apply -var-file=environments/prod.tfvars
```

## 📊 Variáveis Principais

| Variável        | Descrição                   | Exemplo                |
|-----------------|-----------------------------|------------------------|
| project_name    | Nome do projeto             | mycompany-network      |
| aws_region      | Região AWS                  | us-east-1              |
| environment     | Ambiente                    | (dev/staging/prod) dev |
| vpc_cidr        | CIDR da VPC                 | 10.0.0.0/16            |
| public_subnets  | CIDRs de sub-redes públicas | ["10.0.1.0/24"]        |
| private_subnets | CIDRs de sub-redes privadas | ["10.0.10.0/24"]       |

### 🔒 Segurança

- Utilize sempre o princípio de mínimo privilégio
- Mantenha os grupos de segurança restritivos
- Utilize chaves gerenciadas pela AWS ou KMS