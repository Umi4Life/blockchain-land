<template>
    <div>
        <v-data-table
            :headers="headers"
            :items="requests"
            :sort-desc="[false, true]"
            multi-sort
            class="elevation-1"
        >
            <template v-slot:item.action="{ item }">
                <v-btn small @click="onClickAccept(item)" color="success">Accept</v-btn>
                <v-btn small @click="onClickReject(item)" color="error">Reject</v-btn>
            </template>
        </v-data-table>
        <!-- Reject modal -->
        <v-dialog v-model="rejectModal" persistent max-width="600px">
            <v-card>
            <v-card-title>
            <span class="headline">Reject Request</span>
            </v-card-title>
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
                        <p>{{request.company}}</p>
                        <div class="text--primary">
                            {{request.reason}}
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
                </v-card-text>
                <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text @click="rejectModal = false">cancel</v-btn>
                <v-btn color="blue darken-1" text @click="reject">reject</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>    
        <!-- Accept Modal -->
        <v-dialog v-model="acceptModal" persistent max-width="600px">
            <v-card>
            <v-card-title>
            <span class="headline">Accept Request</span>
            </v-card-title>
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
                        <p>{{request.company}}</p>
                        <div class="text--primary">
                            {{request.reason}}
                        </div>
                        </v-card-text>
                    </v-card>
                    <!-- Lands -->
                    <v-card>
                        <v-card-title>
                            Valid
                        </v-card-title>
                        <v-data-table
                            :headers="landHeaders"
                            :items="request.lands"
                            item-key="landID"
                            show-select
                            class="elevation-1"
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
                        ></v-text-field>
                    </v-col>
                </v-card-text>
                <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="blue darken-1" text @click="acceptModal = false">cancel</v-btn>
                <v-btn color="blue darken-1" text @click="accept">accept</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

    </div>
</template>

<script>
  export default {
    data () {
      return {
        singleSelect: false,
        selected: [],
        acceptModal: false,
        rejectModal: false,
        request: {
                ID: '123',
                company: 'v-bit',
                reason: 'cuz...',
                land: []
            },
        landHeaders: [
            { text: 'Province', value: 'province' },
          { text: 'District', value: 'district' },
          { text: 'LandID', value: 'landID' }
        ],
        headers: [
          {
            text: 'Request ID',
            align: 'left',
            sortable: false,
            value: 'ID',
          },
          { text: 'Campany name', value: 'company' },
          { text: 'Reason', value: 'reason' },
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
    methods:{
        onClickAccept(item){
            this.acceptModal = true;
            this.request = item;
        },
        onClickReject(item){
            this.rejectModal = true;
            this.request = item;
        },
        reject(){
            this.rejectModal = false;
        },
        accept(){
            this.acceptModal = false;
        }
    },
  }
</script>

