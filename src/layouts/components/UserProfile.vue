<script setup>
import { PerfectScrollbar } from 'vue3-perfect-scrollbar'
import foto_perfil from '@images/avatars/avatar-8.png'

const router = useRouter()

const userProfileList = [
  { type: 'divider' },
  {
    type: 'navItem',
    icon: 'ri-user-line',
    title: 'Minha conta',
    href: '#',
  },
  {
    type: 'navItem',
    icon: 'ri-settings-4-line',
    title: 'Ajustes',
    href: '#',
  },
  { type: 'divider' },
  
  {
    type: 'navItem',
    icon: 'ri-question-line',
    title: 'Ajuda',
    href: '#',
  },
]

const userData = useCookie('userData')

const logout = async () => {
  useCookie.value = null
  userData = null 
  localStorage = null
  await router.push('/login')
}

const storedUserData = JSON.parse(localStorage.getItem("userData"));

</script>

<template>
  <VBadge
    dot
    bordered
    location="bottom right"
    offset-x="2"
    offset-y="2"
    color="success"
    class="user-profile-badge"
  >
    <VAvatar
      class="cursor-pointer"
      size="38"
    >
      <VImg :src="foto_perfil" />

      <VMenu
        activator="parent"
        width="230"
        location="bottom end"
        offset="15px"
      >
        <VList>
          <VListItem class="px-4">
            <div class="d-flex gap-x-2 align-center">
              <VAvatar>
                <VImg :src="foto_perfil" />
              </VAvatar>

              <div>
                <div class="text-body-2 font-weight-medium text-high-emphasis">
                  {{storedUserData.nome}}
                </div>
                <div class="text-capitalize text-caption text-disabled">
                  {{  storedUserData.email }}
                </div>
              </div>
            </div>
          </VListItem>

          <PerfectScrollbar :options="{ wheelPropagation: false }">
            <template
              v-for="item in userProfileList"
              :key="item.title"
            >
              <VListItem
                v-if="item.type === 'navItem'"
                :href="item.href"
                class="px-4"
              >
                <template #prepend>
                  <VIcon
                    :icon="item.icon"
                    size="22"
                  />
                </template>

                <VListItemTitle>{{ item.title }}</VListItemTitle>

                <template
                  v-if="item.chipsProps"
                  #append
                >
                  <VChip
                    v-bind="item.chipsProps"
                    variant="elevated"
                  />
                </template>
              </VListItem>

              <VDivider
                v-else
                class="my-1"
              />
            </template>

            <VListItem class="px-4">
              <VBtn
                block
                color="error"
                size="small"
                append-icon="ri-logout-box-r-line"
                @click="logout"
              >
                Sair
              </VBtn>
            </VListItem>
          </PerfectScrollbar>
        </VList>
      </VMenu>
    
    </VAvatar>
  </VBadge>
</template>

<style lang="scss">
.user-profile-badge {
  &.v-badge--bordered.v-badge--dot .v-badge__badge::after {
    color: rgb(var(--v-theme-background));
  }
}
</style>
