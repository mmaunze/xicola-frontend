<script setup>
import UserBioPanel from '@/views/utilizadores/view/UserBioPanel.vue'
import UserTabBillingsPlans from '@/views/utilizadores/view/UserTabBillingsPlans.vue'
import UserTabConnections from '@/views/utilizadores/view/UserTabConnections.vue'
import UserTabNotifications from '@/views/utilizadores/view/UserTabNotifications.vue'
import UserTabOverview from '@/views/utilizadores/view/UserTabOverview.vue'
import UserTabSecurity from '@/views/utilizadores/view/UserTabSecurity.vue'

const route = useRoute('apps-user-view-id')
const userTab = ref(null)

const tabs = [
  {
    icon: 'ri-group-line',
    title: 'Overview',
  },
  {
    icon: 'ri-lock-2-line',
    title: 'Security',
  },
  {
    icon: 'ri-bookmark-line',
    title: 'Billing & Plan',
  },
  {
    icon: 'ri-notification-4-line',
    title: 'Notifications',
  },
  {
    icon: 'ri-link-m',
    title: 'Connections',
  },
]

const { data: userData } = await useApi(`/utilizadoress/${ route.params.id }`)
</script>

<template>
  <VRow v-if="userData">
    <VCol
      cols="12"
      md="5"
      lg="4"
    >
      <UserBioPanel :user-data="userData" />
    </VCol>

    <VCol
      cols="12"
      md="7"
      lg="8"
    >
      <VTabs
        v-model="userTab"
        class="v-tabs-pill"
      >
        <VTab
          v-for="tab in tabs"
          :key="tab.icon"
        >
          <VIcon
            start
            :icon="tab.icon"
          />
          <span>{{ tab.title }}</span>
        </VTab>
      </VTabs>

      <VWindow
        v-model="userTab"
        class="mt-6 disable-tab-transition"
        :touch="false"
      >
        <VWindowItem>
          <UserTabOverview />
        </VWindowItem>

        <VWindowItem>
          <UserTabSecurity />
        </VWindowItem>

        <VWindowItem>
          <UserTabBillingsPlans />
        </VWindowItem>

        <VWindowItem>
          <UserTabNotifications />
        </VWindowItem>

        <VWindowItem>
          <UserTabConnections />
        </VWindowItem>
      </VWindow>
    </VCol>
  </VRow>
  <div v-else>
    <VAlert
      type="error"
      variant="tonal"
    >
      Invoice with ID  {{ route.params.id }} not found!
    </VAlert>
  </div>
</template>
