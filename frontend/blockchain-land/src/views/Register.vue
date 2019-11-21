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
          <v-card class="elevation-12">
            <v-toolbar
                    color="primary"
                    dark
                    flat
            >
              <v-toolbar-title>Register form</v-toolbar-title>
              <v-spacer />
            </v-toolbar>
            <v-card-text>
              <v-form>
                <v-text-field
                        label="Email"
                        name="email"
                        type="email"
                        v-model="email"
                />

                <v-text-field
                        label="Company name"
                        name="Company name"
                />

                <v-text-field
                        id="password"
                        label="Password"
                        name="password"
                        type="password"
                        v-model="password"
                />
                <v-text-field
                        id="Confirm password"
                        label="Comfirm password"
                        name="Confirm password"
                        type="password"
                        v-model="password"
                />
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-spacer />
              <v-btn color="primary" @click="register">Sign up</v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </v-content>
</template>

<script>
export default {
    methods:{
        register(){
             
        }
    }
}

</script>