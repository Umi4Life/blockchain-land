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
                                    v-model="reason"
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
    // const CONTRACT = Web3.eth.Contract(ABI,contractAddress)
    export default {
        name: "request",
        data: () => ({
            reason: "",
            items: [
                {
                    province: "",
                    district: "",
                    landNo: "",
                },
            ],
        }),
        beforeCreate () {
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(
                    'https://rinkeby.infura.io/v3/be6ca8f2fa9e482f9a2e45127499434f'));
                web3.eth.getBlockNumber().then(blockNumber => {
                    console.log('Block number = ' + blockNumber);
                }).catch(console.error);
                web3.eth.getBalance('0x2B81009886091E1e0B66e7D292cde3De882015B5').then(wei => {
                    const ether = web3.utils.fromWei(wei, 'ether');
                    console.log('ether = ' + ether);
                    console.log('wei = ' + wei);
                }).catch(console.error);
            } else {
                console.error('Cannot find web3');
            }
        },
        computed: {
            web3 () {
                return this.$store.state.web3
            }
        },
        methods: {
            removeItem: function (i){
                let index = this.items.indexOf(i,);
                this.items.splice(index, 1);
            },
            addItem: function (){
                this.items.push({
                    province: "",
                    district: "",
                    landNo: "",
                },)
            },
            send: function (){
                let out = {
                    companyReason: this.reason,
                    lands: this.items,
                    status: "unverified"
                }
                console.log(JSON.stringify(out))
            },

        }
    }
</script>

<style scoped>


</style>