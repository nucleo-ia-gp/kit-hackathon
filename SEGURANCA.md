# O que nunca entra num repositório público

> ⚠️ **O seu repositório é público desde o primeiro commit.** Não é um detalhe do Edital: é
> prova de autoria, é o que a organização parceira leva no fim, e é o que a banca abre.
>
> ⇒ **E é por isso que ele é o lugar mais fácil de errar de forma irreversível.**

## A regra que explica todas as outras

**Apagar o arquivo não apaga o histórico.**

Se você commitou uma chave e no commit seguinte apagou, ela continua lá, recuperável por
qualquer pessoa, para sempre. `git rm` remove do estado atual, não do passado. Reescrever
o histórico é possível, difícil, e **não alcança cópias que alguém já clonou**.

⇒ **Por isso a única defesa que funciona é não commitar.** Conferir antes custa dez
segundos; consertar depois às vezes não é possível.

## O que nunca vai

### 🔴 Credenciais

Chave de API · senha · token · `Bearer` · chave privada (`BEGIN ... PRIVATE KEY`) · string
de conexão com senha dentro (`postgres://usuario:senha@host`) · cookie de sessão · QR de
autenticação.

⇒ **O que fazer em vez disso:** ponha os **nomes** em `.env.example`, os **valores** em
`.env`, e garanta que `.env` está no `.gitignore` (já está, neste kit).

⚠️ **E o `.env.example` também é vigiado**: ali vão **nomes sem valor**. Colar a chave
"só para o time ver" é o jeito mais comum de vazar.

### 🔴 Dado pessoal de gente real

**Nome completo · e-mail · telefone · CPF · RG · endereço · data de nascimento · foto
identificável · prontuário · matrícula · dado de saúde.**

⚠️ Vale para **qualquer pessoa**, e vale em dobro para quem não é da sua equipe:
beneficiário da organização parceira, voluntário, doador, aluno, paciente. **Essas pessoas
não escolheram estar no seu repositório.**

⇒ Isso inclui lugares que não parecem arquivo de dado:

- planilha ou CSV que a organização mandou;
- **captura de tela** com nome ou e-mail visível na janela;
- log de erro colado no README ou numa issue;
- dado de teste que você "pegou do sistema real para ser realista";
- `git config user.email` de terceiro em commit feito na máquina de outra pessoa.

⇒ **O que fazer em vez disso:** gere **dado sintético** com a mesma estrutura. Se precisar
de 200 linhas parecidas com as reais, gere 200 linhas inventadas — a IA da sua equipe faz
isso em um minuto, e o protótipo demonstra igual.

### 🟠 Coisas que parecem inofensivas e não são

- **URL interna** ou endereço de servidor da organização;
- **nome de pessoa dentro da mensagem de commit** — mensagem de commit **não** é alcançada
  por nenhuma limpeza de arquivo e é o que menos gente lembra de revisar;
- documento interno da organização que ela não publicou;
- contrato, orçamento, proposta comercial.

## Antes de cada push

```bash
./scripts/checar-repo.sh
```

Ele confere licença, segredo aparente, `.env` versionado, `.env.example` sem valor, charter
e ferramentas.

⚠️ **E ele confere FORMA, não garante segurança.** É varredura por padrão: pega o que
*parece* segredo. **Um segredo escrito de um jeito que ela não conhece passa**, e dado
pessoal dentro de um CSV ela não julga. ⇒ Rode `./scripts/checar-repo.sh --auto-teste` para
ver a sonda provar que sabe reprovar, e continue olhando com os próprios olhos.

## ⇒ Se já aconteceu

**Avise a equipe na hora. Não tente esconder.**

1. **Revogue a credencial imediatamente**, antes de qualquer coisa no git. Chave revogada
   é chave inútil, mesmo publicada.
2. **Troque a senha** onde ela foi usada.
3. Se for **dado pessoal de terceiro**, avise a organização parceira: a decisão sobre o que
   fazer é dela, não sua.
4. Só depois pense no histórico.

⚠️ **Ninguém é penalizado por avisar cedo.** O que custa caro é a chave que ficou viva
porque alguém teve vergonha de contar.
