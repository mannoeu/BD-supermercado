-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 29-Jul-2019 às 05:10
-- Versão do servidor: 10.1.39-MariaDB
-- versão do PHP: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `teste`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserirproduto` (`nomeP` VARCHAR(50), `categoriaP` VARCHAR(50), `descriçãoP` VARCHAR(55), `preço_unit_p` DECIMAL(10,2))  BEGIN 
    IF nomeP !='' AND categoriaP !='' and descriçãoP !='' and preço_unit_p !='' THEN 
    insert into produto (Categoria,Nome,Descrição,Preço_unit) values (categoriaP,nomeP,descriçãoP,preço_unit_p); 
    ELSE 
    Select 'Preencha todos os campos' AS Mensagem; 
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `maiorpreco` ()  BEGIN 
	select max(preço_unit) AS Preço, Nome from produto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `novasenha` (`cpf_f` BIGINT, `novasenha` VARCHAR(55))  BEGIN
	if cpf_f != '' and novasenha !='' THEN
	update login set senha = novasenha where CPF = cpf_f;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `produtosvendidos` ()  BEGIN
	select nome from produto, vendaproduto where produto.cod_prod = vendaproduto.cod_prod GROUP BY nome;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `pagamentodinheiro` () RETURNS INT(11) BEGIN
	DECLARE tipo int;
    	select count(Cod_pgt) INTO tipo from vendaproduto where Cod_pgt = 1;
    RETURN tipo;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `totalfunc` () RETURNS INT(11) BEGIN
	DECLARE total_f int;
	select count(DISTINCT CPF) INTO total_f from funcionário;
RETURN total_f;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `valortotalvendasfunc` (`nomeF` VARCHAR(55)) RETURNS DECIMAL(10,2) BEGIN
    DECLARE
        valortotal DECIMAL(10, 2);
    SELECT
        SUM(valor_total)
    INTO valortotal
FROM
    funcionário
INNER JOIN caixa ON funcionário.cpf = caixa.cpf
INNER JOIN venda ON caixa.cod_caixa = venda.cod_caixa AND funcionário.nome = nomeF; RETURN valortotal;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `abasteceestoque`
--

CREATE TABLE `abasteceestoque` (
  `Id_estoque` bigint(5) NOT NULL,
  `CNPJ` bigint(14) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `abasteceestoque`
--

INSERT INTO `abasteceestoque` (`Id_estoque`, `CNPJ`) VALUES
(1, 11548275690942),
(1, 24356889000420),
(1, 44985602984564);

-- --------------------------------------------------------

--
-- Estrutura da tabela `caixa`
--

CREATE TABLE `caixa` (
  `Cod_caixa` bigint(5) NOT NULL,
  `CPF` bigint(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `caixa`
--

INSERT INTO `caixa` (`Cod_caixa`, `CPF`) VALUES
(1, 11411928450),
(2, 11498284829),
(3, 97868758440);

-- --------------------------------------------------------

--
-- Estrutura da tabela `estoque`
--

CREATE TABLE `estoque` (
  `Id_estoque` bigint(5) NOT NULL,
  `Estado` varchar(30) NOT NULL,
  `Cidade` varchar(30) NOT NULL,
  `Bairro` varchar(30) NOT NULL,
  `Rua` varchar(100) NOT NULL,
  `Número` bigint(10) NOT NULL,
  `Estoque_min` bigint(10) NOT NULL,
  `Estoque_atual` bigint(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `estoque`
--

INSERT INTO `estoque` (`Id_estoque`, `Estado`, `Cidade`, `Bairro`, `Rua`, `Número`, `Estoque_min`, `Estoque_atual`) VALUES
(1, 'RN', 'Afonso Bezerra', 'Cabugi', 'R. Professor Manoel Januário', 994, 5000, 3968);

-- --------------------------------------------------------

--
-- Estrutura da tabela `estoqueproduto`
--

CREATE TABLE `estoqueproduto` (
  `Cod_prod` bigint(5) NOT NULL,
  `Id_estoque` bigint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `estoqueproduto`
--

INSERT INTO `estoqueproduto` (`Cod_prod`, `Id_estoque`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `fornecedor`
--

CREATE TABLE `fornecedor` (
  `CNPJ` bigint(14) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Estado` varchar(30) NOT NULL,
  `Cidade` varchar(30) NOT NULL,
  `Bairro` varchar(100) NOT NULL,
  `Rua` varchar(30) NOT NULL,
  `Número` bigint(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `fornecedor`
--

INSERT INTO `fornecedor` (`CNPJ`, `Nome`, `Estado`, `Cidade`, `Bairro`, `Rua`, `Número`) VALUES
(11548275690942, 'Recanto dos Grãos', 'RN', 'Alto do Rodrigues', 'Madagascar', 'Travessa Coronel Antônio Pinto', 568),
(24356889000420, 'J Edilson', 'RN', 'Angicos', 'Alto da Alegria', 'Av. Miguel Castro', 459),
(44985602984564, 'Casa das Massas', 'RN', 'Alto do Rodrigues', 'Progênesis', 'R. Prof Antonia Mendes', 98);

-- --------------------------------------------------------

--
-- Stand-in structure for view `funcionariocaixa`
-- (See below for the actual view)
--
CREATE TABLE `funcionariocaixa` (
`nome` varchar(50)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `funcionário`
--

CREATE TABLE `funcionário` (
  `CPF` bigint(11) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Cargo` varchar(20) NOT NULL,
  `Data_contrato` date NOT NULL,
  `Salário` decimal(10,0) NOT NULL,
  `Estado` varchar(30) NOT NULL,
  `Cidade` varchar(30) NOT NULL,
  `Bairro` varchar(30) NOT NULL,
  `Rua` varchar(30) NOT NULL,
  `Número` bigint(10) NOT NULL,
  `CPF_supervisor` bigint(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `funcionário`
--

INSERT INTO `funcionário` (`CPF`, `Nome`, `Cargo`, `Data_contrato`, `Salário`, `Estado`, `Cidade`, `Bairro`, `Rua`, `Número`, `CPF_supervisor`) VALUES
(11411928450, 'Ingridy', 'Operador de Caixa', '2006-06-12', '1000', 'RN', 'Angicos', 'Alto da Alegria', 'Av. Miguel Castro', 99, 44466655520),
(11498284829, 'Marcos', 'Operador de Caixa', '2000-04-04', '1000', 'RN', 'Afonso Bezerra', 'Cabugi', 'R. Manoel Januário', 3, 44466655520),
(44466655520, 'Emmanuel', 'Supervisor', '1998-04-29', '1800', 'RN', 'Alto do Rodrigues', 'Progênesis', 'R. Prof Antonia Mendes', 3, 0),
(97868758440, 'Julia', 'Operador de Caixa', '2010-01-24', '1000', 'RN', 'Assu', 'Renovo', 'Av. Dom Pablo', 54, 44466655520);

--
-- Acionadores `funcionário`
--
DELIMITER $$
CREATE TRIGGER `novologinf` AFTER INSERT ON `funcionário` FOR EACH ROW BEGIN
	if NEW.CPF_supervisor != 0 THEN
    	insert into login (Senha, CPF) values ('senhapadrao123',NEW.CPF);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `login`
--

CREATE TABLE `login` (
  `Id` bigint(10) NOT NULL,
  `CPF` bigint(11) NOT NULL,
  `Senha` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `login`
--

INSERT INTO `login` (`Id`, `CPF`, `Senha`) VALUES
(1, 11411928450, '@ingridy98'),
(2, 11498284829, 'marcos123'),
(3, 97868758440, 'deusefiel22');

-- --------------------------------------------------------

--
-- Estrutura da tabela `pagamento`
--

CREATE TABLE `pagamento` (
  `Cod_pgt` bigint(5) NOT NULL,
  `Tipo` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `pagamento`
--

INSERT INTO `pagamento` (`Cod_pgt`, `Tipo`) VALUES
(1, 'Dinheiro'),
(2, 'Crédito'),
(3, 'Débito');

-- --------------------------------------------------------

--
-- Estrutura da tabela `produto`
--

CREATE TABLE `produto` (
  `Cod_prod` bigint(5) NOT NULL,
  `Categoria` varchar(20) NOT NULL,
  `Nome` varchar(30) NOT NULL,
  `Descrição` varchar(255) NOT NULL,
  `Preço_unit` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `produto`
--

INSERT INTO `produto` (`Cod_prod`, `Categoria`, `Nome`, `Descrição`, `Preço_unit`) VALUES
(1, 'Massa', 'Macarrão', 'Massa para espaguete', '2.50'),
(2, 'Molho', 'Molho de tomate', 'Molho de tomate concentrado', '2.00'),
(3, 'Grão', 'Feijão Preto', 'Feijão preto', '4.00'),
(4, 'Líquido', 'Oléo de girassol', 'Óleo para fritura', '4.00'),
(5, 'Grão', 'Arroz', 'Parboilizado', '2.78'),
(7, 'Grão', 'Feijão Preto', 'Fava', '3.99');

-- --------------------------------------------------------

--
-- Stand-in structure for view `qtdfornecedorbycidade`
-- (See below for the actual view)
--
CREATE TABLE `qtdfornecedorbycidade` (
`Quantidade` bigint(21)
,`Cidade` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `qtdprodutobycategoria`
-- (See below for the actual view)
--
CREATE TABLE `qtdprodutobycategoria` (
`Quantidade` bigint(21)
,`Categoria` varchar(20)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `registrologin`
--

CREATE TABLE `registrologin` (
  `Id` bigint(10) NOT NULL,
  `Cod_caixa` bigint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `registrologin`
--

INSERT INTO `registrologin` (`Id`, `Cod_caixa`) VALUES
(1, 1),
(2, 2),
(3, 3);

-- --------------------------------------------------------

--
-- Estrutura da tabela `venda`
--

CREATE TABLE `venda` (
  `Id_venda` bigint(5) NOT NULL,
  `Quantidade` bigint(10) NOT NULL,
  `Data_venda` date NOT NULL,
  `Valor_total` decimal(10,2) NOT NULL,
  `Cod_caixa` bigint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `venda`
--

INSERT INTO `venda` (`Id_venda`, `Quantidade`, `Data_venda`, `Valor_total`, `Cod_caixa`) VALUES
(1, 1, '2019-07-25', '2.50', 1),
(2, 2, '2019-07-25', '4.00', 2),
(3, 8, '2019-07-25', '32.00', 3);

--
-- Acionadores `venda`
--
DELIMITER $$
CREATE TRIGGER `estoquevenda` AFTER INSERT ON `venda` FOR EACH ROW BEGIN 
    update estoque set estoque_atual = estoque_atual - NEW.quantidade;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `vendaproduto`
--

CREATE TABLE `vendaproduto` (
  `Id_venda` bigint(5) NOT NULL,
  `Cod_prod` bigint(5) NOT NULL,
  `Cod_pgt` bigint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `vendaproduto`
--

INSERT INTO `vendaproduto` (`Id_venda`, `Cod_prod`, `Cod_pgt`) VALUES
(1, 1, 1),
(2, 2, 3),
(3, 3, 2);

--
-- Acionadores `vendaproduto`
--
DELIMITER $$
CREATE TRIGGER `delvenda` AFTER DELETE ON `vendaproduto` FOR EACH ROW BEGIN
	delete from venda where Id_venda = OLD.Id_venda;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `funcionariocaixa`
--
DROP TABLE IF EXISTS `funcionariocaixa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `funcionariocaixa`  AS  select `funcionário`.`Nome` AS `nome` from `funcionário` where (`funcionário`.`CPF_supervisor` <> 0) ;

-- --------------------------------------------------------

--
-- Structure for view `qtdfornecedorbycidade`
--
DROP TABLE IF EXISTS `qtdfornecedorbycidade`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `qtdfornecedorbycidade`  AS  select count(`fornecedor`.`CNPJ`) AS `Quantidade`,`fornecedor`.`Cidade` AS `Cidade` from `fornecedor` group by `fornecedor`.`Cidade` ;

-- --------------------------------------------------------

--
-- Structure for view `qtdprodutobycategoria`
--
DROP TABLE IF EXISTS `qtdprodutobycategoria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `qtdprodutobycategoria`  AS  select count(`produto`.`Cod_prod`) AS `Quantidade`,`produto`.`Categoria` AS `Categoria` from `produto` group by `produto`.`Categoria` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `abasteceestoque`
--
ALTER TABLE `abasteceestoque`
  ADD KEY `Id_estoque` (`Id_estoque`),
  ADD KEY `CNPJ` (`CNPJ`);

--
-- Indexes for table `caixa`
--
ALTER TABLE `caixa`
  ADD PRIMARY KEY (`Cod_caixa`),
  ADD KEY `CPF` (`CPF`);

--
-- Indexes for table `estoque`
--
ALTER TABLE `estoque`
  ADD PRIMARY KEY (`Id_estoque`);

--
-- Indexes for table `estoqueproduto`
--
ALTER TABLE `estoqueproduto`
  ADD KEY `Cod_prod` (`Cod_prod`),
  ADD KEY `Id_estoque` (`Id_estoque`);

--
-- Indexes for table `fornecedor`
--
ALTER TABLE `fornecedor`
  ADD PRIMARY KEY (`CNPJ`);

--
-- Indexes for table `funcionário`
--
ALTER TABLE `funcionário`
  ADD PRIMARY KEY (`CPF`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `CPF` (`CPF`);

--
-- Indexes for table `pagamento`
--
ALTER TABLE `pagamento`
  ADD PRIMARY KEY (`Cod_pgt`);

--
-- Indexes for table `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`Cod_prod`);

--
-- Indexes for table `registrologin`
--
ALTER TABLE `registrologin`
  ADD KEY `Id` (`Id`),
  ADD KEY `Cod_caixa` (`Cod_caixa`);

--
-- Indexes for table `venda`
--
ALTER TABLE `venda`
  ADD PRIMARY KEY (`Id_venda`),
  ADD KEY `Cod_caixa` (`Cod_caixa`);

--
-- Indexes for table `vendaproduto`
--
ALTER TABLE `vendaproduto`
  ADD KEY `Cod_pgt` (`Cod_pgt`),
  ADD KEY `Cod_prod` (`Cod_prod`),
  ADD KEY `Id_venda` (`Id_venda`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `caixa`
--
ALTER TABLE `caixa`
  MODIFY `Cod_caixa` bigint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `estoque`
--
ALTER TABLE `estoque`
  MODIFY `Id_estoque` bigint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fornecedor`
--
ALTER TABLE `fornecedor`
  MODIFY `CNPJ` bigint(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44985602984565;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `Id` bigint(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pagamento`
--
ALTER TABLE `pagamento`
  MODIFY `Cod_pgt` bigint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `produto`
--
ALTER TABLE `produto`
  MODIFY `Cod_prod` bigint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `venda`
--
ALTER TABLE `venda`
  MODIFY `Id_venda` bigint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `abasteceestoque`
--
ALTER TABLE `abasteceestoque`
  ADD CONSTRAINT `abasteceestoque_ibfk_1` FOREIGN KEY (`Id_estoque`) REFERENCES `estoque` (`Id_estoque`),
  ADD CONSTRAINT `abasteceestoque_ibfk_2` FOREIGN KEY (`CNPJ`) REFERENCES `fornecedor` (`CNPJ`);

--
-- Limitadores para a tabela `caixa`
--
ALTER TABLE `caixa`
  ADD CONSTRAINT `caixa_ibfk_1` FOREIGN KEY (`CPF`) REFERENCES `funcionário` (`CPF`);

--
-- Limitadores para a tabela `estoqueproduto`
--
ALTER TABLE `estoqueproduto`
  ADD CONSTRAINT `estoqueproduto_ibfk_1` FOREIGN KEY (`Cod_prod`) REFERENCES `produto` (`Cod_prod`),
  ADD CONSTRAINT `estoqueproduto_ibfk_2` FOREIGN KEY (`Id_estoque`) REFERENCES `estoque` (`Id_estoque`);

--
-- Limitadores para a tabela `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`CPF`) REFERENCES `funcionário` (`CPF`);

--
-- Limitadores para a tabela `registrologin`
--
ALTER TABLE `registrologin`
  ADD CONSTRAINT `registrologin_ibfk_1` FOREIGN KEY (`Id`) REFERENCES `login` (`Id`),
  ADD CONSTRAINT `registrologin_ibfk_2` FOREIGN KEY (`Cod_caixa`) REFERENCES `caixa` (`Cod_caixa`);

--
-- Limitadores para a tabela `venda`
--
ALTER TABLE `venda`
  ADD CONSTRAINT `venda_ibfk_1` FOREIGN KEY (`Cod_caixa`) REFERENCES `caixa` (`Cod_caixa`);

--
-- Limitadores para a tabela `vendaproduto`
--
ALTER TABLE `vendaproduto`
  ADD CONSTRAINT `vendaproduto_ibfk_1` FOREIGN KEY (`Cod_pgt`) REFERENCES `pagamento` (`Cod_pgt`),
  ADD CONSTRAINT `vendaproduto_ibfk_2` FOREIGN KEY (`Cod_prod`) REFERENCES `produto` (`Cod_prod`),
  ADD CONSTRAINT `vendaproduto_ibfk_3` FOREIGN KEY (`Id_venda`) REFERENCES `venda` (`Id_venda`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
