<p align="center">
    <img src="./../images/sql-masterclas-banner.png" alt="sql-masterclass-banner">
</p>

[![forthebadge](./../images/badges/version-1.0.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)]()
[![forthebadge](https://forthebadge.com/images/badges/ctrl-c-ctrl-v.svg)]()

# Step 12 - Final Case Study Questions

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step11.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step13.md)

To finish up our entire cryptocurrency case study - let's now calculate exactly the same query that we just created for Nandita's data with our entire dataset with all mentors included!

## Create The Base Table

> Create a summary table `mentor_performance` which includes the following metrics for each member and ticker:

* Count of purchase transactions
* Initial investment
* Purchase fees
* Dollar cost average of purchases
* Count of sales transactions
* Gross revenue amount
* Sales fees
* Average selling price
* Actual Profitability (final portfolio value + gross sales revenue - purchase fees - sales fees) / initial investment amount
* Theoretical Profitability (final portfolio value with no sales - purchase fees) / initial investment amount

<details><summary>Click here to reveal the solution!</summary><br>

```sql
CREATE TEMP TABLE mentor_performance AS
WITH cte_portfolio AS (
  SELECT
    members.first_name,
    members.region,
    transactions.ticker,
    transactions.txn_type,
    COUNT(*) AS transaction_count,
    SUM(transactions.quantity) AS total_quantity,
    SUM(transactions.quantity * prices.price) AS gross_values,
    SUM(transactions.quantity * prices.price * transactions.percentage_fee / 100) AS fees 
  FROM trading.transactions
  INNER JOIN trading.members
    ON transactions.member_id = members.member_id
  INNER JOIN trading.prices
    ON transactions.ticker = prices.ticker
    AND transactions.txn_date = prices.market_date
  GROUP BY
    members.first_name,
    members.region,
    transactions.ticker,
    transactions.txn_type
),
cte_summary AS (
  SELECT
    first_name,
    region,
    ticker,
    SUM(
      CASE
        WHEN txn_type = 'BUY' THEN total_quantity
        WHEN txn_type = 'SELL' THEN -total_quantity
      END
    ) AS final_quantity,
    SUM(CASE WHEN txn_type = 'BUY' THEN gross_values ELSE 0 END) AS initial_investment,
    SUM(CASE WHEN txn_type = 'SELL' THEN gross_values ELSE 0 END) AS sales_revenue,
    SUM(CASE WHEN txn_type = 'BUY' THEN fees ELSE 0 END) AS purchase_fees,
    SUM(CASE WHEN txn_type = 'SELL' THEN fees ELSE 0 END) AS sales_fees,
    SUM(CASE WHEN txn_type = 'BUY' THEN total_quantity ELSE 0 END) AS purchase_quantity,
    SUM(CASE WHEN txn_type = 'SELL' THEN total_quantity ELSE 0 END) AS sales_quantity,
    SUM(CASE WHEN txn_type = 'BUY' THEN transaction_count ELSE 0 END) AS purchase_transactions,
    SUM(CASE WHEN txn_type = 'SELL' THEN transaction_count ELSE 0 END) AS sales_transactions
  FROM cte_portfolio
  GROUP BY
    first_name,
    region,
    ticker
),
cte_metrics AS (
  SELECT
    summary.first_name,
    summary.region,
    summary.ticker,
    summary.final_quantity * final.price AS actual_final_value,
    summary.purchase_quantity * final.price AS theoretical_final_value,
    summary.sales_revenue,
    summary.purchase_fees,
    summary.sales_fees,
    summary.initial_investment,
    summary.purchase_quantity,
    summary.sales_quantity,
    summary.purchase_transactions,
    summary.sales_transactions,
    summary.initial_investment / purchase_quantity AS dollar_cost_average,
    summary.sales_revenue / sales_quantity AS average_selling_price
  FROM cte_summary AS summary
  INNER JOIN trading.prices AS final
    ON summary.ticker = final.ticker
  WHERE final.market_date = '2021-08-29'
)
SELECT
  first_name,
  region,
  ticker,
  actual_final_value AS final_portfolio_value,
  ( actual_final_value + sales_revenue - purchase_fees - sales_fees ) / initial_investment AS actual_profitability,
  ( theoretical_final_value - purchase_fees ) / initial_investment AS theoretical_profitability,
  dollar_cost_average,
  average_selling_price,
  sales_revenue,
  purchase_fees,
  sales_fees,
  initial_investment,
  purchase_quantity,
  sales_quantity,
  purchase_transactions,
  sales_transactions
FROM cte_metrics;
```

</details><br>

Make sure to checkout the results from the temp table by running a `SELECT` query before tackling the following questions!

```sql
SELECT * FROM mentor_performance;
```

**Warning - this is a very very wide table!!!**

| first_name |    region     | ticker |     final_portfolio_value     |  actual_profitability   | theoretical_profitability |    dollar_cost_average    |  average_selling_price   |        sales_revenue        |        purchase_fees         |         sales_fees         |      initial_investment      |    purchase_quantity    |    sales_quantity     | purchase_transactions | sales_transactions |
| ---------- | ------------- | ------ | ----------------------------- | ----------------------- | ------------------------- | ------------------------- | ------------------------ | --------------------------- | ---------------------------- | -------------------------- | ---------------------------- | ----------------------- | --------------------- | --------------------- | ------------------ |
| Vipul      | United States | ETH    |  13102554.8171483815588462536 | 4.672465959057919903182 |   5.314621992146962886758 |   597.6673234944262953386 |    626.24202540473186303 |    456793.90734028892884625 |   7104.569887725402883402542 |  1188.37948073671816727685 |  2900193.5795488220132164898 |  4852.52157101720575379 |   729.420717245970714 |                   991 |                149 |
| Vikram     | India         | ETH    |    6276426.482786365114210656 |  4.31181306610612708721 |    5.89972140484864266246 |    538.402092304626902638 |   576.741885087371095795 |   557225.943027915290149790 |    4169.62855809858209505223 |  1467.03920970122463238123 |   1583560.245623696053185812 |   2941.2223099752008596 |  966.1617396549943312 |                   577 |                204 |
| Sonia      | Australia     | ETH    |  11320688.2256349723009004896 | 4.478791700263700984631 |   5.292086399343751113029 |   600.1977155852074903438 |  547.8389664223296338686 |  444504.2206952554872967260 |   6743.608268140600050792052 | 1074.114521166652869369938 |  2625122.0218275999023003858 |  4373.76210149024236043 | 811.37751773682107399 |                   864 |                161 |
| Rowan      | United States | ETH    |   4678642.5109952568421167048 | 5.074269504377240055910 |    6.70449304368406104767 |    473.813548833111016754 |  451.5349656200992805727 |  262663.3359667433250122461 |    2383.35566531251972219524 |  617.385725289504123294627 |    973205.128602539867412883 |   2053.9833252960165058 | 581.71206211245256233 |                   398 |                127 |
| Pavan      | Australia     | ETH    |    4188486.703924433521762992 |  3.85446785580589944402 |    6.16497270013013441338 |    515.248248322169372184 |   531.294867143263816005 |   572045.492969362533176448 |    3229.56956929045240213967 |  1350.07976580743016281956 |   1233880.453924375664710254 |   2394.7300314796354124 | 1076.7005825695475786 |                   462 |                215 |
| Nandita    | United States | ETH    |   11134790.869485909819250128 |  4.94126554503705553061 |    5.30805715638391209991 |    598.397257883758534604 |   542.484898862480594053 |   172591.915512909206341725 |    5783.32678170688531189239 |   447.93810830446683009024 |   2287096.578215583047801140 |   3822.0371970017654265 |  318.1506358514526923 |                   756 |                 70 |
| Leah       | Asia          | ETH    |   5011670.9776990206825808176 | 4.270686580003484588095 |    5.48302943975337301171 |    579.309226305712103035 |  661.5229873200303442848 |  403560.1542523780850137170 |    3216.06018209301609128188 |  986.188509194701148571051 |   1267016.153467224471656408 |   2187.1154401373141792 | 610.04706108140806606 |                   435 |                126 |
| Enoch      | Africa        | ETH    |   2183933.3382704268238606128 | 2.927688747446586597299 |   5.826836991147052000975 |   545.1397546539025353837 |    571.75035531306719678 |    604577.95275612948938510 |   2441.664983053686080567615 |  1602.26015552138487694330 |   951080.3934730024378543018 |  1744.65425673609669642 |  1057.415963344853958 |                   351 |                209 |
| Danny      | Australia     | ETH    |   11138441.431815681783446160 |  5.08249463426467766581 |    6.23008931789695811035 |    509.872366169852376539 |   566.702626000625094273 |   573254.802885147022737177 |    5824.68526547388391619532 |  1455.00530622275440216891 |   2302888.126083087786695727 |   4516.5972484100717280 | 1011.5619313973581290 |                   904 |                200 |
| Charlie    | United States | ETH    |    5655595.638497926206310488 |  4.38490746540649869678 |    5.82323930041798717653 |     545.48335086195787859 |   636.245983138421001829 |   505215.393166603619467180 |    3500.08393571387478289503 |  1162.34054359444856996608 |    1403940.36949523667356874 |    2573.754757641582429 |  794.0567116424364033 |                   501 |                158 |
| Ben        | Australia     | ETH    |  13428404.7308956467466546296 | 5.566492182258915860530 |   5.798153939300467470194 |   547.8409611043090877031 |    575.24111102831531919 |    124538.44970426124410866 |   6102.488840463623164634342 |   311.46640129618281001108 |  2433584.5235770879150933104 |  4442.13685422790551869 |   216.497825549417380 |                   877 |                 44 |
| Ayush      | United States | ETH    |    1311604.529255899622334984 |  2.68703356830932432729 |    5.81625080031458481996 |    546.136841365536146123 |   472.423274839163292495 |   334003.599653997130003622 |    1535.33554277335488666741 |   874.60265072177019376644 |    611528.717056667941945237 |   1119.7353314008790779 |  707.0007288859948728 |                   222 |                145 |
| Alex       | United States | ETH    |   8166074.5514961468370127832 | 5.160548701564200259435 |   6.195710408303723678880 |   512.7005436032844769009 |    594.10347686987495653 |    394356.04132861779977087 |   4190.280933001530243794585 |  1055.12264813874726085400 |  1657805.3389265534531313035 |  3233.47685039578173973 |   663.783426089917745 |                   651 |                136 |
| Abe        | United States | ETH    |    6639149.360373732402400560 |  6.30636732390684560266 |    6.96696762485071066549 |    455.956218714819773258 |   402.869591682089677282 |   102436.515287599786845294 |    2830.40882752809559852513 |   280.26871378724081389402 |   1068519.299942312419013546 |   2343.4690790139731866 |  254.2671807517156776 |                   452 |                 49 |
| Vipul      | United States | BTC    |   78502964.072588956226743050 |  2.68714530854748256805 |    3.68294320587067762687 |   13093.31447811552297915 | 13475.453907836528677637 | 13126372.591344438019363620 |   86003.42201666670006452538 | 33121.33857697519500985826 |   34054805.89838476266109091 |   2600.9308762349498788 | 974.09502352354264169 |                   491 |                202 |
| Vikram     | India         | BTC    |  166813181.437258245953618100 |  3.52715101148526165567 |    3.95599133132907749521 |   12190.13846337579877423 | 11616.444334417796046131 |  6676932.386251731199555320 |  124651.51307436673592167471 | 16956.79224576098138040873 |   49146890.77777644033111307 |   4031.6925788360780822 | 574.78279876648434158 |                   792 |                115 |
| Sonia      | Australia     | BTC    |   124284811.35069950050073250 |  3.22239151512076129431 |    3.98017619235346804918 |   12116.19259536080282520 |  13301.41484742083517680 |  12188130.03561228407096717 |  106218.63998275465210197183 | 32557.52213358600760727724 |   42308380.15320625283012337 |   3491.8873912094965336 |  916.3032786678013621 |                   692 |                192 |
| Rowan      | United States | BTC    |  123967563.642518772902551350 |  3.21604584843623520833 |    3.99480787192328942564 |   12071.72576961881153034 | 14698.463685865612609155 | 14674630.646730677455969795 |  109785.90179561532962420871 | 34896.99704422013042418676 |   43064532.63337412145429443 |   3567.3882471515063849 | 998.37853535959315513 |                   731 |                192 |
| Pavan      | Australia     | BTC    |    74876626.12728888362311500 |  2.96170097119995459091 |    4.19446871610550698321 |   11497.41992360170303301 |  12736.34639275082929004 |  13102135.31594895329161890 |   75946.04432629785510284083 | 35021.69278578816478913785 |   29668016.64332961950593339 |   2580.4064599247725600 | 1028.7200828179673870 |                   526 |                197 |
| Nandita    | United States | BTC    | 200751409.8030429976334624250 | 3.318954506414827841503 |   3.800967820444996477195 | 12686.9187126851255182628 |  12710.97315213559195557 |  10975745.05336688201117242 | 162919.943377863222128081502 | 29522.09286188312984442411 | 63735345.6973630892576024850 | 5023.705687783492459935 |  863.4858182768507102 |                   954 |                167 |
| Leah       | Asia          | BTC    |  195244116.218934723675250200 |  3.20713866637997563156 |    3.69585020094976729586 |  13047.716421455726604292 |  14163.27115481523942743 |  13167023.04333994792518748 |  162182.80997147155924445895 | 34511.92424266569639230177 |  64922183.350145074994503074 |  4975.75064119164404784 |  929.6597445190769838 |                   985 |                178 |
| Enoch      | Africa        | BTC    |  170580708.903959882263220550 |  3.32210366299759732651 |    3.81349609220645770901 |   12645.17491200523085792 | 12221.728791595667220353 |  8993630.724672519050054694 |  139549.78578174917338018370 | 22127.73733517252665241326 |   54005738.62395010934056671 |   4270.8573823425313401 | 735.87222217343213249 |                   820 |                146 |
| Danny      | Australia     | BTC    |   159477000.13128947514105900 |  3.15215421180060014193 |    3.86323307663085347221 |   12482.56627031336321059 |  12136.89819062786950087 |  13053993.84143928202879456 |  139898.65835627135429570787 | 33921.86482473383782701913 |   54679169.18667898299926584 |   4380.4429315724604872 | 1075.5626055691556454 |                   841 |                216 |
| Charlie    | United States | BTC    |  122534214.004535973744886950 |  3.72521619894663216642 |    4.00865603400732590012 |  12029.849955058029497028 |   16533.3629303089026886 |    5048387.7946428438527447 |   89519.44751889309135946118 |   13459.650465263838174873 |  34220731.332920134486598673 |  2844.65155099725936589 |   305.345489355233177 |                   557 |                 51 |
| Ben        | Australia     | BTC    |   174495457.85993726210654700 |  3.58080995618084189922 |    3.72643936325482578725 |   12940.57274048096941435 |   12007.5028729516103273 |    2379058.8188878469437270 |  124879.65939037520247690716 |  6292.82529374197896891580 |   49358482.11912615398782341 |   3814.2424689381731354 |   198.131022250011036 |                   738 |                 38 |
| Ayush      | United States | BTC    |  190375533.507735667440266700 |  3.60665921157546573899 |    3.94587234371446856760 |  12221.424291634983319324 |  11627.47349802419417012 |   5849092.67497492474683032 |  137094.21663401017780783864 | 15782.14185896643545309336 |  54363813.801684160086909672 |  4448.23880624893711454 |  503.0407229884321422 |                   879 |                 95 |
| Alex       | United States | BTC    |   106225322.51226045757462950 |  3.17134902464366229781 |    3.64732289428635720234 |   13221.31584224600059279 |   10912.7808704054692250 |    4864305.0963092239886611 |   86273.62341244515836663134 |   12991.807119280435744693 |   34997838.87410784294077066 |   2647.0768334782105019 |   445.743862547520261 |                   534 |                 84 |
| Abe        | United States | BTC    |   179533509.46040851816270350 |  3.45022907603633744257 |    4.02573821957975606285 |   11978.89286334087078326 |  11297.72474955164239817 |   9629772.49687926822047538 |  142276.80367018421615985439 | 24216.72648756990733881614 |   54778040.60600280511777383 |   4572.8800842388871361 |  852.3638794847991004 |                   900 |                171 |
<br>

## Question 1

> Which mentors have the greatest actual profitability for each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_ranks AS (
SELECT
  first_name,
  ticker,
  actual_profitability,
  RANK() OVER (PARTITION BY ticker ORDER BY actual_profitability DESC) AS profitability_rank
FROM mentor_performance
)
SELECT * FROM cte_ranks
WHERE profitability_rank = 1;
```

</details><br>

| first_name | ticker |  actual_profitability  | profitability_rank |
| ---------- | ------ | ---------------------- | ------------------ |
| Charlie    | BTC    | 3.72521619894663216642 |                  1 |
| Abe        | ETH    | 6.30636732390684560266 |                  1 |
<br>

## Question 2

> Which mentors have the greatest difference in actual vs theoretical profitability for each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_ranks AS (
SELECT
  first_name,
  ticker,
  ABS(actual_profitability - theoretical_profitability) AS difference,
  RANK() OVER (
    PARTITION BY ticker
    ORDER BY ABS(actual_profitability - theoretical_profitability) DESC
  ) AS difference_rank
FROM mentor_performance
)
SELECT * FROM cte_ranks
WHERE difference_rank = 1;
```

</details><br>

| first_name | ticker |       difference       | difference_rank |
| ---------- | ------ | ---------------------- | --------------- |
| Pavan      | BTC    | 1.23276774490555239230 |               1 |
| Ayush      | ETH    | 3.12921723200526049267 |               1 |
<br>

## Question 3

> What is the total amount of sales revenue made by all mentors for each region? (combined BTC and ETH)

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  region,
  SUM(sales_revenue) AS total_sales
FROM mentor_performance
GROUP BY region
ORDER BY total_sales DESC;
```

</details><br>

|    region     |         total_sales          |
| ------------- | ---------------------------- |
| United States | 66396367.0625050180915045221 |
| Australia     | 42437660.9781423926224266410 |
| Asia          | 13570583.1975923260102011970 |
| Africa        |   9598208.677428648539439794 |
| India         |   7234158.329279646489705110 |
<br>

## Question 4

> What is the average actual profitability for each region for each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
SELECT
  region,
  ticker,
  AVG(actual_profitability) AS avg_profitability
FROM mentor_performance
GROUP BY region, ticker
ORDER BY ticker, avg_profitability DESC;
```

</details><br>

|    region     | ticker |    avg_profitability    |
| ------------- | ------ | ----------------------- |
| India         | BTC    |  3.52715101148526165567 |
| Africa        | BTC    |  3.32210366299759732651 |
| United States | BTC    | 3.310799882085806180525 |
| Australia     | BTC    |  3.22926416357553948159 |
| Asia          | BTC    |  3.20713866637997563156 |
| United States | ETH    | 4.746694009665583482267 |
| Australia     | ETH    | 4.745561593148298488748 |
| India         | ETH    |  4.31181306610612708721 |
| Asia          | ETH    | 4.270686580003484588095 |
| Africa        | ETH    | 2.927688747446586597299 |
<br>

## Question 5

> Which mentors have the largest initial investment in each ticker?

<details><summary>Click here to reveal the solution!</summary><br>

```sql
WITH cte_rank AS (
SELECT
  first_name,
  ticker,
  initial_investment,
  RANK() OVER (PARTITION BY ticker ORDER BY initial_investment DESC) AS investment_rank
FROM mentor_performance
)
SELECT * FROM cte_rank
WHERE investment_rank = 1;
```

</details><br>

| first_name | ticker |     initial_investment      | investment_rank |
| ---------- | ------ | --------------------------- | --------------- |
| Leah       | BTC    | 64922183.350145074994503074 |               1 |
| Vipul      | ETH    | 2900193.5795488220132164898 |               1 |
<br>

[![forthebadge](./../images/badges/go-to-previous-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step11.md)
[![forthebadge](./../images/badges/go-to-next-tutorial.svg)](https://github.com/datawithdanny/sql-masterclass/tree/main/course-content/step13.md)