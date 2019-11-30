<template>
    <v-app id="inspire">
        <v-app-bar
                app
                color="cyan"
                dark
        >
            <v-toolbar-title>Blockchain Land</v-toolbar-title>
            <v-spacer />
            <v-divider vertical></v-divider>
            <v-btn v-if="authed" @click="home()" text>Home</v-btn>
            <v-divider vertical></v-divider>
            <v-btn v-if="authed" @click="signOut()" text>Logout</v-btn>
            <v-divider vertical></v-divider>

        </v-app-bar>

        <v-content>
            <v-container
                    class="fill-height"
                    fluid
            >
                <v-row
                        align="center"
                >
                    <v-col class="text-center">
                        <!--CONTENT-->




                        <!--<div id="nav">-->
                            <!--<router-link to="/login">Login</router-link> |-->
                            <!--<router-link to="/about">About</router-link>-->
                        <!--</div>-->
                        <h1 v-if="loading"> <v-progress-circular indeterminate/></h1>
                        <router-view v-else :size="200"/>





                        <!--CONTENT-->
                    </v-col>
                </v-row>
            </v-container>
        </v-content>

        <v-footer
                color="cyan"
                app
        >
            <v-spacer />

            <span class="white--text">Satoshi Jr.  &copy; 2019 | </span>
            <router-link to="/aboutus" class="white--text"> About Us</router-link>
        </v-footer>
    </v-app>
</template>

<script>
    import firebase from "firebase"
    import router from "./router/index"
    import store from "./store/index"
    export default {
        name: 'app',
        components: {
    },
        props: {
            source: String,
        },
        data: () => ({
        }),
        computed: {
            loading () {
                return store.getters.getLoading
            },
            authed(){
                return store.getters.getUid
            }
        },
        methods:{
            home: function() {
                router.replace("/home")
            },
            signOut: function (){
                store.commit('setLoading', true);
                firebase.auth().signOut()
                    .then(function(){
                        router.replace('/login')
                        store.commit('setLoading', false);
                        store.commit('setUid', null);

                    })
            }
        }
    }
</script>
