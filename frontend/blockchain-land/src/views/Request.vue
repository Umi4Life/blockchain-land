<template>
    <v-content>
        <v-container
                class="fill-height"
                fluid
        >
            <v-row
                    align="center"
                    justify="center"
            >
                <v-col
                        cols="12"
                        sm="8"
                        md="4"
                >

                    <v-card  class="elevation-12" >
                        <v-card-text>
                            <v-textarea
                                    v-model="companyReason"
                                    color="teal"
                                    label="Reason(s)"
                            >
                            </v-textarea>
                        </v-card-text>
                    </v-card>

                </v-col>
            </v-row>



            <v-row
                    v-for="i in this.items" v-bind:key="i.id"
                    align="center"
                    justify="center"
            >
                <v-col
                        cols="12"
                        sm="8"
                        md="4"
                >

                    <v-card  class="elevation-12" >
                        <v-card-actions>
                            <v-spacer />
                            <v-btn text icon color="black"
                            @click="removeItem(i)">
                                <v-icon>mdi-trash-can-outline</v-icon>
                            </v-btn>
                        </v-card-actions>
                        <v-card-text>
                            <v-form>
                                <v-text-field
                                        label="Province"
                                        v-model="i.province"
                                />

                                <v-text-field
                                        label="District"
                                        v-model="i.district"
                                />
                                <v-text-field
                                        label="Land No."
                                        v-model="i.landNo"
                                />
                            </v-form>
                        </v-card-text>

                    </v-card>



                </v-col>
            </v-row>

            <v-row
                    align="center"
                    justify="center"
            >
                <v-col
                >
                    <v-btn text icon color="black"
                    @click="addItem">
                    <v-icon x-large>mdi-plus-circle</v-icon>
                </v-btn>
                </v-col>
            </v-row>

            <v-row
                    align="center"
                    justify="center"
            >
                <v-col
                >
                    <v-text-field
                            label="Private Key"
                            v-model="key"
                            type="password"
                    />
                    <v-btn color="success" dark large
                    @click="send">
                        Send
                    </v-btn>
                </v-col>
            </v-row>
        </v-container>
    </v-content>
</template>

<script>
    import Web3 from 'web3'
    import store from '../store/index'
    import sha256 from 'js-sha256'
    import firebase from 'firebase'
    import * as web3const from '../util/web3const'
    export default {
        name: "request",
        data: () => ({
            companyReason: "",
            items: [
                {
                    district: "",
                    landNo: "",
                    province: "",
                },
            ],
            key: "",
        }),
        beforeCreate () {
        },
        computed: {
            uid () {
                return store.getters.getUid
            },
        },
        methods: {
            signAndSendTransaction: function (web3, account, transaction) {
                return account.signTransaction(transaction).then( function (results) {
                    if ('rawTransaction' in results) {
                        web3.eth.sendSignedTransaction(results.rawTransaction).then(function (receipt) {
                            console.log(receipt)
                            // contractAddress.value = receipt.contractAddress;
                            // contractAddress.isDeploying = false;
                        }).catch(console.error);
                    } else {
                        // contractAddress.value = "Cannot find rawTransaction in results";
                        // contractAddress.isDeploying = false;
                    }

                })
                    .catch(console.error);
            },
            removeItem: function (i){
                let index = this.items.indexOf(i,);
                this.items.splice(index, 1);
            },
            addItem: function (){
                this.items.push({
                    district: "",
                    landNo: "",
                    province: "",
                },)
            },
            send: function (){
                let out = {
                    companyReason: this.companyReason,
                    lands: this.items,
                    status: "unverified"
                }
                const id = Math.floor(Math.random() * (Math.pow(2,64)+1)).toString();

                let sha = sha256(JSON.stringify(out))
                firebase.database().ref('users/' + this.uid + '/requests/').child(id).set(out)

                if(Web3){
                    const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                    const account = web3.eth.accounts.privateKeyToAccount('0x' + this.key);
                    const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                    var encodedABI = contract.methods.sendRequest(sha).encodeABI();
                    this.signAndSendTransaction(web3, account, {
                        from: "0x2B81009886091E1e0B66e7D292cde3De882015B5",
                        to: web3const.CONTRACTADDRESS,
                        gas: '30000',
                        data: encodedABI
                    });

                }

            },

        }
    }
</script>

<style scoped>


</style>