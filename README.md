# Ice-Chain
Ice Chain is the IoT dApp project aimed to simplify cooperation between operators of the sensitive cargoes. The project offers the all-purpose financial instrument to replace cargo insurance or bank letter of credit and provide the close tie between transportation service quality and effecting payments. 

This should be provided by the interaction between measuring Temperature Data Logger (TDL) device and Qtum-based smart contract.

See our [Business plan](https://drive.google.com/file/d/17s6qXawPR3rnK8C85eox69PzEkbdI73v/view?usp=sharing) to get full description of the project and its detailed business dimension.
Also, visit pur [website](http://icechain.tilda.ws/qtum#rec66323650) and live [Medium](https://medium.com/@icechain) blog.

## Solving problems
We found out a several points we intend to improve at the market of sensitive cargo logistics.

* Hard to find out who is responsible for the cargo damage.
  *There is no transport insurance for temperature damages of sensitive cargoes
* The company's' working capital gets trapped on accounts of their partners for the time of legal proceedings
  *The processes of financial deals execution are to slow in the field of sensitive cargoes transportation
* Mistrust on the markets which, on top of everything else, makes barriers for SME-companies
  *Small transportation companies can't get access to the market due to lack of reputation despite the possibility to meet customer expectations
  
## Solution
Ice Chain offers the solution based on Qtum smart contract, which is based on traditional LC scheme but also rectifies its common deficiencies. 

### Smart contract: 1 solution
![Smart contract 1 solution](https://static.tildacdn.com/tild3130-3963-4261-b530-336264333332/__2018-09-10__182541.png)

**Step 1.** The buyer and the seller create a smart contract. They set all the basic terms such as the exact date of delivery and temperature range.

**Step 2.** The buyer (B) places the value of goods on the account of smart contract. The seller forwards goods by carrier. While transportation, the temperature data loggers (TDLs) measure temperature in the batch and record measures to the log.

**Step 3.** When the goods come to the buyer's warehouse, a warehouse worker uses special mobile application to automatically get the logs and send them to blockchain. Smart contract checks the temperature logs and searches for deviations. If there is no deviations found, smart contract transfers the payment to the account of the seller. Otherwise, the payment goes back to the buyer. 

### Smart contract: 2 solution
According to Institute Cargo Clauses rules, temperature risks shouldn't be insured, as they lie close to force majeure circumstances. Therefore, there are serious obstacles for those companies who operate with temperature-sensitive cargoes. To solve this problem, Ice Chain offers another use of its smart contract 

![Smart contract 2 solution](https://static.tildacdn.com/tild3634-6539-4935-b739-353666333530/__2018-09-10__182821.png)

**Solution.** The transport operator (A) places the insurance deposit to the account. Then, the process goes as described before. Finally, in case of success, the deposit goes back to A. Otherwise, it goes to B (Buyer, or Cargo owner) as a compensation. 

# Authors
* **[Dan Kalinichenko](https://www.linkedin.com/in/kalinichenkoda/)** - Project Leader. Leads Business Plan developing. 
* **[Romano Potechin](https://www.linkedin.com/in/romano-potechin-b3203415a/)** - Head of Technology. Leads Temperature Data Logger (TDL) device development.
* **[Thomas Luong](https://www.linkedin.com/in/luongthomas/)** - Lead Developer. Leads Ice Chain app development.
