<template>
    <v-app id="inspire">
        <v-app-bar
                app
                color="cyan"
                dark
        >
            <v-spacer />

            <v-toolbar-title>Application</v-toolbar-title>
        </v-app-bar>

        <v-content>
            <v-container
                    class="fill-height"
                    fluid
            >
                <v-row
                        align="center"
                        justify="center"
                >
                    <v-col class="text-center">
                        <!--CONTENT-->




                        <!--<div id="nav">-->
                            <!--<router-link to="/login">Login</router-link> |-->
                            <!--<router-link to="/about">About</router-link>-->
                        <!--</div>-->
                        <router-view/>





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

            <span class="white--text">&copy; 2019</span>
        </v-footer>
    </v-app>
</template>

<script>
    export default {
        name: 'app',
        components: {
    },
        props: {
            source: String,
        },
        data: () => ({
        }),
    }
</script>
