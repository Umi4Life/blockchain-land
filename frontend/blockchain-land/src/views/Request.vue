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
                                    v-model="this.reason"
                                    color="teal"
                            >
                                <template v-slot:label>
                                    <div>
                                        Reason(s)
                                    </div>
                                </template>
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

                    <v-card transition="slide-y-transition" class="elevation-12" >
                        <template v-slot:activator="{ on }">
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
                        </template>
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
        methods: {
            removeItem: function (i){
                // this.items.splice(, 1);
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
                console.log(this.items)
            }
        }
    }
</script>

<style scoped>
    .fade-enter-active, .fade-leave-active {
        transition: opacity .5s;
    }

</style>