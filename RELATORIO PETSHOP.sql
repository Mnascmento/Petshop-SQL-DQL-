-- Relatório 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente;
SELECT e.nome "Nome", e.cpf "CPF", e.dataAdm "Data de Admissão", e.salario "Salário", d.nome "Departamento", t.numero "Numero de Telefone"
FROM empregado e
INNER JOIN departamento d ON e.Departamento_idDepartamento = d.idDepartamento
LEFT JOIN telefone t ON t.Empregado_cpf = e.cpf
WHERE e.dataAdm BETWEEN '2019-01-01' AND '2022-03-31'
GROUP BY e.cpf
ORDER BY e.dataAdm DESC;

-- Relatório 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por nome do empregado;
SELECT e.nome "Nome", e.cpf "CPF", e.dataAdm "Data de Admissão", e.salario "Salário", d.nome "Departamento", t.numero "Numero de Telefone"
FROM empregado AS e
INNER JOIN departamento AS d ON e.Departamento_idDepartamento = d.idDepartamento
LEFT JOIN telefone AS t ON t.Empregado_cpf = e.cpf
GROUP BY e.cpf
HAVING e.salario < (SELECT AVG(salario) FROM empregado)
ORDER BY e.nome;

-- Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão), ordenado por nome do departamento;
SELECT d.nome "Departamento", COUNT(e.cpf) "Quantidade de Empregados", ROUND(AVG(e.salario), 2) "Média Salarial", ROUND(AVG(e.comissao), 2) "Média da Comissão"
FROM departamento d
INNER JOIN empregado e ON e.Departamento_idDepartamento = d.idDepartamento
GROUP BY d.idDepartamento
ORDER BY d.nome;

-- Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas;
SELECT e.nome "Nome Empregado", e.cpf "CPF Empregado", e.sexo "Sexo", e.salario "Salário", COUNT(v.Empregado_cpf) "Quantidade Vendas", SUM(v.valor) "Total Valor Vendido", SUM(v.comissao) "Total Comissão das Vendas"
FROM empregado e
INNER JOIN venda v ON e.cpf = v.Empregado_cpf
GROUP BY v.Empregado_cpf
ORDER BY COUNT(v.idVenda) DESC;

-- Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço), ordenado por quantidade total de vendas realizadas;
SELECT e.nome "Nome Empregado", e.cpf "CPF Empregado",  e.sexo "Sexo", e.salario "Salário", COUNT(i.Empregado_cpf) "Quantidade Vendas com Serviço", SUM(i.valor) "Total Valor Vendido com Serviço", SUM(v.comissao) "Total Comissão das Vendas com Serviço"
FROM empregado e
INNER JOIN itensservico i ON e.cpf = i.Empregado_cpf
INNER JOIN venda v ON i.Venda_idVenda = v.idVenda
GROUP BY e.cpf
ORDER BY COUNT(v.Empregado_cpf) DESC;

-- Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais recente a mais antiga;
SELECT p.nome "Nome do Pet", v.data "Data do Serviço", s.nome "Nome do Serviço", i.quantidade "Quantidade", i.valor "Valor", e.nome "Empregado que realizou o Serviço"
FROM itensservico i
INNER JOIN pet p ON i.PET_idPET = p.idPET
INNER JOIN venda v ON v.idVenda = i.Venda_idVenda
INNER JOIN servico s ON i.Servico_idServico = s.idServico
INNER JOIN empregado e ON e.cpf = i.Empregado_cpf
ORDER BY v.data DESC;

-- Relatório 7 - Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda), ordenado por data do serviço da mais recente a mais antiga;
SELECT v.data "Data da Venda", v.valor "Valor", v.desconto "Desconto", (v.valor - v.desconto) "Valor Final", e.nome "Empregado que realizou a venda"
FROM venda v
INNER JOIN empregado e ON e.cpf = v.Empregado_cpf
ORDER BY v.data DESC;

-- Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido, trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;
SELECT s.nome "Nome do Serviço", COUNT(i.Servico_idServico) "Quantidade Vendas", SUM(i.valor) "Total Valor Vendido"
FROM servico s
LEFT JOIN itensservico i ON i.Servico_idServico = s.idServico
GROUP BY i.Servico_idServico
ORDER BY COUNT(i.Servico_idServico) DESC
LIMIT 10;

-- Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;
SELECT f.tipo "Tipo Forma Pagamento", COUNT(f.Venda_idVenda) "Quantidade Vendas", SUM(f.valorPago) "Total Valor Vendido"
FROM formapgvenda f
GROUP BY f.tipo
ORDER BY COUNT(f.Venda_idVenda) DESC;

-- Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga;
SELECT DATE(v.data) "Data Venda", COUNT(v.idVenda) "Quantidade de Vendas", SUM(v.valor) "Valor Total Venda"
FROM venda v
GROUP BY DATE(v.data)
ORDER BY DATE(v.data) DESC;

-- Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto;
SELECT p.nome "Nome Produto", p.valorVenda "Valor Produto", f.nome "Nome Fornecedor", f.email "Email Fornecedor", t.numero "Telefone Fornecedor"
-- CATEGORIA DE PRODUTOS NÃO EXISTE NO BANCO DE DADOS FORNECIDO
FROM produtos p
INNER JOIN itenscompra i ON p.idProduto = i.Produtos_idProduto
INNER JOIN compras c ON i.Compras_idCompra = c.idCompra
INNER JOIN fornecedor f ON c.Fornecedor_cpf_cnpj = f.cpf_cnpj
LEFT JOIN telefone t ON f.cpf_cnpj = t.Fornecedor_cpf_cnpj
ORDER BY p.nome DESC;

-- Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas;
SELECT p.nome "Nome Produto", COUNT(i.Venda_idVenda) "Quantidade (Total) Vendas", SUM(i.valor) "Valor Total Recebido pela Venda do Produto"
FROM produtos p
LEFT JOIN itensvendaprod i ON i.Produto_idProduto = p.idProduto
GROUP BY p.idProduto
ORDER BY COUNT(i.Venda_idVenda) DESC;