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
                >
        <v-data-table
            :headers="headers"
            :items="requests"
            :sort-desc="[false, true]"
            multi-sort
            class="elevation-1"
        >
            <template v-slot:item.action="{ item }">
                <v-btn small @click="onClickAccept(item, modal)" color="success">Accept</v-btn>
                <v-btn small @click="onClickReject(item, modal)" color="error">Reject</v-btn>
            </template>
        </v-data-table>
        <!-- Reject modal -->
        <v-dialog v-model="modal.reject" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="headline">Reject Request</span>
                </v-card-title>
            <v-container
                    v-if="modal.loading===true"
            >
                <v-row
                        align="center"
                >
                    <v-col class="text-center">
                        <h1> <v-progress-circular indeterminate/></h1>
                    </v-col>
                </v-row>
            </v-container>

                <v-content v-else>
                <v-card-text>
                    <!-- request info -->
                    <v-card
                        class="mx-auto"
                        max-width="344"
                    >
                        <v-card-text>
                        <div>request ID</div>
                        <p class="display-1 text--primary">
                            {{request.ID}}
                        </p>
                        <p>{{request.companyName}}</p>
                        <p v-if="request.hash" class="green--text">Hash is correct</p>
                        <p v-else class="red--text">Hash is incorrect</p>
                        <div class="text--primary">
                            {{request.companyReason}}
                        </div>
                        </v-card-text>
                    </v-card>
                    <!-- Reasons -->
                    <v-col cols="24">
                        <v-text-field
                            label="Reason(s)"
                            outlined
                            shaped
                        ></v-text-field>
                    </v-col>
                    <v-col cols="24">
                        <v-text-field
                                type="password"
                                label="key"
                                outlined
                                shaped
                                v-model="key"
                        ></v-text-field>
                    </v-col>
                </v-card-text>
                <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text @click="modal.reject = false">cancel</v-btn>
                <v-btn color="blue darken-1" text @click="reject(item, reason, modal)">reject</v-btn>
                </v-card-actions>
                </v-content>
            </v-card>
        </v-dialog>
        <!-- Accept Modal -->
        <v-dialog v-model="modal.accept" max-width="600px">
            <v-card>
            <v-card-title>
            <span class="headline">Accept Request</span>
            </v-card-title>
                <v-container
                        v-if="modal.loading===true"
                >
                    <v-row
                            align="center"
                    >
                        <v-col class="text-center">
                            <h1> <v-progress-circular indeterminate/></h1>
                        </v-col>
                    </v-row>
                </v-container>
                <v-content v-else>
                <v-card-text>
                    <!-- request info -->
                    <v-card
                        class="mx-auto"
                        max-width="344"
                    >
                        <v-card-text>
                        <div>request ID</div>
                        <p class="display-1 text--primary">
                            {{request.ID}}
                        </p>
                        <p>{{request.companyName}}</p>
                        <p v-if="request.hash" class="green--text">Hash is correct</p>
                        <p v-else class="red--text">Hash is incorrect</p>
                        <div class="text--primary">
                            {{request.companyReason}}
                        </div>
                        </v-card-text>
                    </v-card>
                    <!-- Lands -->
                    <v-card>
                        <v-card-title>
                            Invalid
                        </v-card-title>
                        <v-data-table
                            :headers="landHeaders"
                            :items="request.lands"
                            item-key="landNo"
                            show-select
                            class="elevation-1"
                            v-model="selected"
                        >
                            <!-- <template v-slot:top>

                            </template> -->
                        </v-data-table>
                    </v-card>
                    <!-- notes -->
                    <v-col cols="24">
                        <v-text-field
                            label="note"
                            outlined
                            shaped
                            v-model="reason"
                        ></v-text-field>
                    </v-col>
                    <v-col cols="24">
                        <v-text-field
                                type="password"
                                label="key"
                                outlined
                                shaped
                                v-model="key"
                        ></v-text-field>
                    </v-col>
                </v-card-text>
                <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text @click="modal.accept = false">cancel</v-btn>
                <v-btn color="blue darken-1" text @click="accept(item, reason, selected, modal)">accept</v-btn>
                </v-card-actions>
                </v-content>
            </v-card>
        </v-dialog>
            </v-col>
        </v-row>
    </v-container>

    </v-content>
</template>

<script>
    import Web3 from 'web3'
    import store from '../store/index'
    import firebase from 'firebase'
    import * as web3const from '../util/web3const'
    import sha256 from 'js-sha256'
  export default {
    data () {
      return {
      item: null,
          reason: "",
          key: "",
        singleSelect: false,
        selected: [],
        modal:{
            accept: false,
            reject: false,
            loading: false,
        },
        request: {
                ID: '123',
                companyName: 'v-bit',
                companyReason: 'cuz...',
                lands: []
            },
        landHeaders: [
            { text: 'Province', value: 'province' },
          { text: 'District', value: 'district' },
          { text: 'Land ID', value: 'landNo' }
        ],
        headers: [
          {
            text: 'Request ID',
            align: 'left',
            sortable: false,
            value: 'ID',
          },
          { text: 'Company Name', value: 'companyName' },
          { text: 'Reason', value: 'companyReason' },
          { text: 'Actions', value: 'action', sortable: false },
        ],
        // mock request data
        requests: [
            {
                ID: 1234456,
                company: 'golden eagle',
                reason: 'make kratom farm',
                lands:[
                    {
                        province: 'bangkok',
                        district: 'taweewattana',
                        landID: '1234'
                    },
                    {
                        province: 'bangkok',
                        district: 'taweewattana',
                        landID: '1235'
                    }
                    ]
            },
            {
                ID: 1234457,
                company: 'golden eagle',
                reason: 'not much just looking',
                lands: [
                    {
                        province: 'Chiangmai',
                        district: 'Maerim',
                        landID: '2234'
                    },
                    {
                        province: 'Chiangmai',
                        district: 'Maerim',
                        landID: '2235'
                    }
                ]
            }
        ],
      }
    },
      mounted() {
          firebase.database().ref('/requests/').on("value", (snapshot) => {
              let requests = []
              Object.keys(snapshot.val()).forEach(key => {
                  if(snapshot.val()[key].status === "pending..."){
                      requests.push({
                          ID: key,
                          companyName: snapshot.val()[key].companyName,
                          companyReason: snapshot.val()[key].companyReason,
                          status: snapshot.val()[key].status,
                          lands: snapshot.val()[key].lands,

                      })
                  }

              })
              this.requests = requests;
          });
      },
      computed: {
          uid () {
              return store.getters.getUid
          },
      },
    methods:{
        signAndSendTransaction: function (web3, account, modal, transaction) {
            return account.signTransaction(transaction).then( function (results) {
                if ('rawTransaction' in results) {
                    web3.eth.sendSignedTransaction(results.rawTransaction).then(function (receipt) {
                        console.log(results)
                        modal.loading = true
                        modal.accept = false
                        modal.reject = false
                    }).catch(console.error);

                }
            })
                .catch(console.error);
        },
        checkRequest: function(rid, modal, item){
            this.modal.itemHash = sha256(JSON.stringify(item))
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                contract
                    .methods
                    .checkRequest(parseInt(rid))
                    .call()
                    .then(function (result) {
                    })
                    .catch(console.error);
            } else {
                console.error('Cannot find web3');
            }
        },
        onClickAccept(item, modal){
            this.item = item
            modal.loading = true
            modal.accept = true
            var itemHash = sha256(JSON.stringify({
                companyName: item.companyName,
                companyReason: item.companyReason,
                lands: item.lands,
            }))
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);

                contract
                    .methods
                    .checkRequest(parseInt(item.ID))
                    .call()
                    .then(function (result) {

                        item.hash = result[4] === itemHash;
                        modal.loading = false
                    })
                    .catch(console.error);
            } else {
                console.error('Cannot find web3');
            }
            this.request = item;
        },
        onClickReject(item, modal){
            this.item = item
            modal.loading = true
            modal.reject = true
            var itemHash = sha256(JSON.stringify({
                companyName: item.companyName,
                companyReason: item.companyReason,
                lands: item.lands,
            }))
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                contract
                    .methods
                    .checkRequest(parseInt(item.ID))
                    .call()
                    .then(function (result) {

                        item.hash = result[4] === itemHash;
                        modal.loading = false;
                    })
                    .catch(console.error);
            } else {
                console.error('Cannot find web3');
            }
            this.request = item;
        },
        reject(item, reason, modal){
            modal.loading = true;
            let outDb = {
                companyName: item.companyName,
                companyReason: item.companyReason,
                landReason: reason,
                lands: item.lands,
                status: "rejected"
            }
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                const account = web3.eth.accounts.privateKeyToAccount('0x' + this.key);
                const gasPrice = (30000).toString();
                let encodedABI = contract.methods.rejectRequest(parseInt(item.ID)).encodeABI();
                this.signAndSendTransaction(web3, account, modal,{
                    from: account.address,
                    to: web3const.CONTRACTADDRESS,
                    gas: '3000000',
                    data: encodedABI
                });
                firebase.database().ref('requests/').child(item.ID.toString()).update(outDb)
            } else {
                console.error('Cannot find web3');
            }
        },
        accept(item, reason, selected, modal){
            modal.loading = true
            let landid = []
            selected.forEach(key => {
                landid.push(key.landNo)
            })
            let text = reason
            if(landid.length>0){
                text.concat("Invalid lands: " + landid.toString())
            }
            let outDb = {
                companyName: item.companyName,
                companyReason: item.companyReason,
                landReason: text,
                lands: item.lands,
                status: "accepted"
            }
            if (Web3) {
                const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                const account = web3.eth.accounts.privateKeyToAccount('0x' + this.key);
                const gasPrice = (30000).toString();
                console.log(item.ID)
                let encodedABI = contract.methods.acceptRequest(parseInt(item.ID)).encodeABI();
                this.signAndSendTransaction(web3, account, modal, {
                    from: account.address,
                    to: web3const.CONTRACTADDRESS,
                    gas: '3000000',
                    data: encodedABI
                });
                firebase.database().ref('requests/').child(item.ID.toString()).update(outDb)
            } else {
                console.error('Cannot find web3');
            }
        }
    },
  }
</script>

