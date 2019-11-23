<template>
    <v-content>
        <v-container>

            <v-row
                    v-for="(i, j) in this.items"
                    v-bind:data="i"
                    v-bind:key="j"
                    justify="center"
            >
                <v-col
                        cols="12"
                        sm="8"
                        md="4"
                >

                    <v-card  class="elevation-12" >
                        <v-toolbar
                                color="primary"
                                dark
                                flat
                        >
                            <v-toolbar-title>RID: {{j}}</v-toolbar-title>
                            <v-spacer />
                        </v-toolbar>

                        <v-card-text class="title text-left black--text">
                            <div>Reason:  {{i["companyReason"]}}</div>
                            <div>Status: {{i["status"]}}</div>
                            <div>Notes: {{i["landReason"]}}</div>
                            <div>Lands: </div>

                        </v-card-text>


                        <v-list
                        style="max-height: 150px"
                        class="overflow-y-auto grey lighten-3"
                        >
                            <v-list-item
                                    v-for="land in i.lands"
                                    :key="land.id"
                                    @click=""
                            >

                                <v-list-item-content>
                                    <!--<v-list-item-title>-->
                                    <!--<div>{{i.lands.indexOf(land)}} {{i.lands.length}}</div>-->
                                        <div>Province: {{land["province"]}}</div>
                                        <div v-if="land.amphur">Amphur: {{land["amphur"]}}</div>
                                        <div v-if="land.district">District: {{land["district"]}}</div>
                                        <div>Land No.: {{land["landNo"]}}</div>

                                    <v-divider
                                        v-if="i.lands.indexOf(land)+1!== i.lands.length"
                                    ></v-divider>
                                    <!--</v-list-item-title>-->
                                </v-list-item-content>


                            </v-list-item>
                        </v-list>
                            <!--</v-container>-->
                        <!--</v-card-text>-->
                        <v-card-actions>
                            <v-spacer />
                            <v-btn @click="checkRequest(j, modal, i, hashCorrect)" @click.stop="modal.open=true">Check Request</v-btn>
                        </v-card-actions>

                    </v-card>

                </v-col>
            </v-row>
        </v-container>
        <v-dialog
                v-model="modal.open"
                persistent
        >
            <v-card>
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
                <div v-else>
                    <v-toolbar
                            color="primary"
                            dark
                            flat
                    >
                        <v-toolbar-title>RID: {{modal.content[0]}}</v-toolbar-title>
                        <v-spacer />
                    </v-toolbar>
                    <v-card-text class="title text-left black--text">
                        <div>Status: {{modal.content[1]}}</div>
                        <div>Approval: {{modal.content[2]}}</div>
                        <div>Address: {{modal.content[3]}}</div>
                        <div v-if="modal.itemHash===modal.content[4]" class="green--text">Hash: Correct</div>
                        <div v-else class="red--text">Hash: Incorrect</div>
                        <!--<div>Data on displaying: {{modal.itemHash}}</div>-->
                        <!--<div>Data on blockchain: {{modal.content[4]}}</div>-->
                        <!--<div>Hash: {{modal.content[5]}}</div>-->
                    </v-card-text>
                </div>



                <v-card-actions>
                    <v-spacer></v-spacer>

                    <v-btn
                            @click="modal.open = false"
                    >
                        Close
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-content>
</template>

<script>
    import Web3 from 'web3'
    import store from '../store/index'
    import firebase from 'firebase'
    import * as web3const from '../util/web3const'
    import sha256 from 'js-sha256'

    export default {
        name: "checkRequest",
        data: () => ({
            items: null,
            modal: {
                open: false,
                content: null,
                itemHash: "",
                loading: true,
                offsetTop: 0,
            },
            hashCorrect: false,
        }),
        mounted() {
            var rid = null;
            firebase.database().ref('users/' + this.uid + '/requests/')
                .on("value", (snapshot) => {
                console.log(Object.values(snapshot.val()))
                rid = Object.values(snapshot.val())
                firebase.database().ref('requests')
                    .on("value", (snapshot) => {
                        console.log(snapshot.val())
                        const filtered = Object.keys(snapshot.val())
                            .filter(key => rid.includes(key))
                            .reverse()
                            .reduce((obj, key) => {
                                obj[key] = snapshot.val()[key];
                                return obj;
                            }, {});
                        this.items = filtered
                    })

                })
            ;
        },
        watch: {
            modal() {
                console.log('Dialog is closing')
            }
        },
        computed: {
            uid () {
                return store.getters.getUid
            },
            getRequests: function(){

            }
        },
        methods:{
            onScroll (e) {
                this.offsetTop = e.target.scrollTop
            },
            checkRequest: function(rid, modal, item){
                console.log(JSON.stringify(item))
                this.item = item
                modal.loading = true
                this.modal.itemHash = sha256(JSON.stringify({
                    companyName: item.companyName,
                    companyReason: item.companyReason,
                    lands: item.lands,
                }))
                console.log(this.modal.itemHash)
                if (Web3) {
                    const web3 = new Web3(new Web3.providers.HttpProvider(web3const.HTTPPROVIDER));
                    const contract = new web3.eth.Contract(web3const.ABI, web3const.CONTRACTADDRESS);
                    contract
                        .methods
                        .checkRequest(parseInt(rid))
                        .call()
                        .then(function (result) {
                            console.log(result)
                            modal.content = result;
                            modal.loading = false;
                         })
                        .catch(console.error);
                } else {
                    console.error('Cannot find web3');
                }
            }
        }
    }
</script>
