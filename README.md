# Ice Chain
## Summary 
Ice Chain is the IoT dApp project aimed to simplify cooperation between operators of the sensitive cargoes. The project offers the all-purpose financial instrument to replace cargo insurance or bank letter of credit and provide the close tie between transportation service quality and effecting payments. 

This should be provided by the interaction between measuring Temperature Data Logger (TDL) device and **Qtum-based smart contract**. 

See our [Business plan](https://drive.google.com/file/d/17s6qXawPR3rnK8C85eox69PzEkbdI73v/view?usp=sharing) to get full description of the project and its detailed business dimension.
Also, visit our [website](http://icechain.tilda.ws/qtum#rec66323650) and live [Medium](https://medium.com/@icechain) blog.

Check the demo video of Ice Chain project below

[![Alt text](https://img.youtube.com/vi/4n5POTLpsX8/0.jpg)](https://www.youtube.com/watch?v=4n5POTLpsX8)

# Technologies applied
## Smart Contract 
Ice Chain makes use of the mobile platform to allow users to create and validate smart contracts on the blockchain. We required a blockchain technology that allows for smart contract capabilities. Another qualification is that since the mobile platform does not have a lot of memory, it is important that we have a platform that does not require downloading the entire blockchain for running a whole node to operate a smart contract.

QTUM particularly stood out to us because it addresses these two of our needs. The first being that it can run smart contracts. The way it does this is through an Ethereum Virtual Machine (EVM) running on the blockchain. Because of this, QTUM can take advantage of running any existing Ethereum smart contract on QTUM and vice versa.
	
The second is that QTUM can utilize the Simple Payment Verification (SPV) protocol to allow for verification of transactions and execution of smart contracts without the need to run an entire node. This is done because QTUM is using the existing technology of Bitcoin known as the Unspent Transaction Output (UTXO) model. This will allow us to run a light client on the mobile platform for users to create and validate smart contracts.

## Temperature Data (TDL) Logger device 
To deal with the field of cold chain Ice Chain implements Temperature Data Logger Device (TDL) which can measure temperature while transportation and send the temperature log to the mobile app via Bluetooth. 

**Ice Chain TDL**
![Ice Chain TDL](https://cdn-images-1.medium.com/max/800/1*ibqzbaM1mMv8z9CFOcBKYQ.jpeg)

The TDL consists of:
* Prefabricated plastic (or caprolon A-type) round case (⍉60x13 mm) with the holes for the device enable button and micro USB connector for charging the battery (isolated from the crystal logic)
* Two-layer electrical board on fiberglass with microchip Atmega328
* Module JDY-08 Bluetooth Low Energy
* Solid-state temperature sensor (temperature range from -80 ℃  to 80 ℃)
* Battery (>1000 mAh)

**TDL circuit**
![TDL circuit](https://cdn-images-1.medium.com/max/1200/0*Z1I88X3CR_bOYiRT)

# Solving problems
We found out a several points we intend to improve at the market of sensitive cargo logistics.

* Hard to find out who is responsible for the cargo damage among multiple intermediaries in the cold chain.
* The company's' working capital gets trapped on accounts of their partners for the time of legal proceedings. If something went wrong, processes of financial deals execution are too slow in the field of sensitive cargoes transportation.
* Mistrust on the markets which, on top of everything else, makes barriers for SME-companies. The roots of mistrust come from two basic commercial risks: the risk of non-payment or payment delay, and the risk of defective goods supply
  
# Solution
Ice Chain offers the solution based on Qtum smart contract, which is based on traditional LC scheme but also rectifies its common deficiencies. 

## Smart contract: 1 solution
![Smart contract 1 solution](https://static.tildacdn.com/tild3130-3963-4261-b530-336264333332/__2018-09-10__182541.png)

**Step 1.** The buyer and the seller create a smart contract. They set all the basic terms such as the exact date of delivery and temperature range.

**Step 2.** The buyer (B) places the value of goods on the account of smart contract. The seller forwards goods by carrier. While transportation, the temperature data loggers (TDLs) measure temperature in the batch and record measures to the log.

**Step 3.** When the goods come to the buyer's warehouse, a warehouse worker uses special mobile application to automatically get the logs and send them to blockchain. Smart contract checks the temperature logs and searches for deviations. If there is no deviations found, smart contract transfers the payment to the account of the seller. Otherwise, the payment goes back to the buyer. 

## Smart contract: 2 solution
According to London Underwriters Institute Cargo Clauses rules, temperature risks shouldn't be insured, as they lie close to force majeure circumstances. Therefore, there are serious obstacles for those companies who operate with temperature-sensitive cargoes. To solve this problem, Ice Chain offers another use of its smart contract 

![Smart contract 2 solution](https://static.tildacdn.com/tild3634-6539-4935-b739-353666333530/__2018-09-10__182821.png)

**Solution.** The transport operator (A) places the insurance deposit to the account. Then, the process goes as described before. Finally, in case of success, the deposit goes back to A. Otherwise, it goes to B (Buyer, or Cargo owner) as a compensation. 

# Authors
* **[Dan Kalinichenko](https://www.linkedin.com/in/kalinichenkoda/)** - Project Leader. Leads Business Plan developing. 
* **[Romano Potechin](https://www.linkedin.com/in/romano-potechin-b3203415a/)** - Head of Technology. Leads Temperature Data Logger (TDL) device development.
* **[Thomas Luong](https://www.linkedin.com/in/luongthomas/)** - Lead Developer. Leads Ice Chain app development.
