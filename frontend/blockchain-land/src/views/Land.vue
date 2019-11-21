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
                <v-btn small color="success">Accept</v-btn>
                <v-btn small color="error">Reject</v-btn>
                </template>
        </v-data-table>
        
    </div>
</template>

<script>
  export default {
    data () {
      return {
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
        requests: [
            {
                ID: 1234456,
                company: 'golden eagle',
                reason: 'make kratom farm'
            },
            {
                ID: 1234457,
                company: 'golden eagle',
                reason: 'not much just looking'
            }
        ],
      }
    },
    methods:{

    },
  }
</script>

