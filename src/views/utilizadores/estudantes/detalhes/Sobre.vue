<script setup>
const props = defineProps({
  userData: {
    type: Object,
    required: true,
  },
});

const isUserInfoEditDialogVisible = ref(false);
const isUpgradePlanDialogVisible = ref(false);

const resolveEstadoVariant = (estado) => {
  if (estado === "Matriculado")
    return {
      color: "primary",
      icon: "ri-user-line",
    };
  if (estado === "Suspenso")
    return {
      color: "warning",
      icon: "ri-settings-2-line",
    };
  if (estado === "Transferido")
    return {
      color: "success",
      icon: "ri-database-2-line",
    };
  if (estado === "Desistente")
    return {
      color: "info",
      icon: "ri-pencil-line",
    };
  if (estado === "Expulso")
    return {
      color: "error",
      icon: "ri-server-line",
    };

  return {
    color: "info",
    icon: "ri-user-line",
  };
};
</script>

<template>
  <VRow>
    <!-- SECTION User Details -->
    <VCol cols="12">
      <VCard v-if="props.userData">
        <VCardText class="text-center pt-12 pb-6">
          <!-- 👉 Avatar -->
          <VAvatar
            rounded="lg"
            :size="120"
            :color="!props.userData.avatar ? 'primary' : undefined"
            :variant="!props.userData.avatar ? 'tonal' : undefined"
          >
            <VImg v-if="props.userData.avatar" :src="props.userData.avatar" />
            <span v-else class="text-5xl font-weight-medium">
              {{ avatarText(props.userData.nomeCompleto) }}
            </span>
          </VAvatar>

        
          <h5 class="text-h5 mt-4">
            {{ props.userData.nomeCompleto }}
          </h5>

        
          <VChip
            :color="resolveEstadoVariant(props.userData.estado).color"
            size="small"
            class="text-capitalize mt-4"
          >
            {{ props.userData.estado }}
          </VChip>
        </VCardText>

        <VCardText class="pb-6">
          <h5 class="text-h6">Detalhes do aluno</h5>

          <VDivider class="my-4" />

          <!-- 👉 User Details list -->
          <VList class="card-list">
            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Data de Nascimento : </span>
                <span class="text-body-1">{{
                  props.userData.dataNascimento
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium"
                  >Província de Nascimento :
                </span>
                <span class="text-body-1">{{
                  props.userData.provinciaNascimento
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium"
                  >Distrito de Nascimento :
                </span>
                <span class="text-body-1">{{
                  props.userData.distritoNascimento
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Data de Registo : </span>
                <span class="text-body-1">{{
                  props.userData.dataRegisto
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">BI : </span>
                <span class="text-body-1">{{
                  props.userData.bilheteIdentificacao
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Telefone : </span>
                <span class="text-body-1">{{
                  props.userData.numeroTelefonePrincipal
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Nome do Pai : </span>
                <span class="text-body-1">{{ props.userData.nomeDoPai }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Nome da Mãe : </span>
                <span class="text-body-1">{{ props.userData.nomeDaMae }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Religião : </span>
                <span class="text-body-1">{{ props.userData.religiao }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Grupo Sanguíneo : </span>
                <span class="text-body-1">{{
                  props.userData.grupoSanguineo
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Endereço : </span>
                <span class="text-body-1">{{ props.userData.endereco }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Escola Anterior : </span>
                <span class="text-body-1">{{
                  props.userData.escolaAnterior
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Estado : </span>
                <span class="text-body-1">{{ props.userData.estado }}</span>
              </VListItemTitle>
            </VListItem>
          </VList>
        </VCardText>

        <!-- 👉 Edit and Suspend button -->
        <VCardText class="d-flex justify-center">
          <VBtn
            variant="elevated"
            class="me-4"
            @click="isUserInfoEditDialogVisible = true"
          >
            Editar
          </VBtn>
          <VBtn variant="outlined" color="error"> Suspender </VBtn>
        </VCardText>
      </VCard>
    </VCol>
    <!-- !SECTION -->
  </VRow>

  <!-- 👉 Edit user info dialog -->
  <UserInfoEditDialog
    v-model:isDialogVisible="isUserInfoEditDialogVisible"
    :user-data="props.userData"
  />

  <!-- 👉 Upgrade plan dialog -->
  <UserUpgradePlanDialog v-model:isDialogVisible="isUpgradePlanDialogVisible" />
</template>

<style lang="scss" scoped>
.card-list {
  --v-card-list-gap: 0.5rem;
}

.current-plan {
  border: 2px solid rgb(var(--v-theme-primary));
}

.text-capitalize {
  text-transform: capitalize !important;
}
</style>
