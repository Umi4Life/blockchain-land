<template>
  <div class="home">

    <h1>Blockchain Land</h1>
    <h2 v-if="token.loading">Checking tokens left... <v-progress-circular indeterminate/></h2>
    <h2 v-else class="grey--text light">Tokens left: {{token.value}}</h2>
    <router-link to="/Request">Request | </router-link>
    <router-link to="/CheckRequest">Check Request</router-link>

    <v-container v-if="debug">
      <v-row justify="center" align="center">

        <v-col cols="12" sm="6" md="3">
          <v-text-field
                  label="Address"
                  v-model="address"
          />
        </v-col>

        <v-col cols="12" sm="6" md="3">
          <v-text-field
                  label="Private key"
                  type="password"
                  v-model="key"
          />
        </v-col>
      </v-row>

      <v-btn v-if="!this.contractAddress.isDeploying" @click="deployRequest(address,key)">Deploy Contract</v-btn>
      <h1>{{this.contractAddress.value}}</h1>
      <h1 v-if="this.contractAddress.isDeploying"> <v-progress-circular/></h1>

    </v-container>

  </div>
</template>

<script>
    import Web3 from 'web3'
    import store from '../store/index'
    import firebase from 'firebase'
    import * as web3const from '../util/web3const'
    export default {
        name: "home",
        data: () => ({
            debug: false,
            address: "0x2B81009886091E1e0B66e7D292cde3De882015B5",
            key: "",
            contractAddress: {
                value: " ",
                isDeploying: false
            },
            token: {
                loading: true,
                value: 0
            },
        }),
        mounted(){
            let token = this.token
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                contract
                    .methods
                    .balanceOf(this.address)
                    .call()
                    .then(function (result) {
                        token.value = result
                        token.loading = false
                    })
                    .catch(console.error);
            } else {
                console.error('Cannot find web3');
            }
        },
        methods:{
            signAndSendTransaction: function (web3, contractAddress, account, transaction) {
                return account.signTransaction(transaction).then( function (results) {
                    if ('rawTransaction' in results) {
                        web3.eth.sendSignedTransaction(results.rawTransaction).then(function (receipt) {
                            contractAddress.value = receipt.contractAddress;
                            contractAddress.isDeploying = false;
                        }).catch(console.error);
                    } else {
                        contractAddress.value = "Cannot find rawTransaction in results";
                        contractAddress.isDeploying = false;
                      }

                    })
                    .catch(console.error);
            },
            deployRequest: function (source, key) {
                if (Web3) {
                    this.contractAddress.isDeploying = true;
                    const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                    const account = web3.eth.accounts.privateKeyToAccount('0x' + key);
                    console.log(account);
                    if (account.address !== source) {
                        console.error('Key mismatch!')
                    } else {
                        this.signAndSendTransaction(web3, this.contractAddress, account, {
                            gas: '3000000',
                            data: '0x' + web3const.BYTECODE
                        })

                    }
                } else {
                    console.error('Cannot find web3');
                }
            },
        }
    }
</script>
