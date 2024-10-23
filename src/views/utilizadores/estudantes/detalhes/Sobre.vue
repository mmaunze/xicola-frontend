<script setup>
import EditarEstudante from "../forms/EditarAluno.vue";

const props = defineProps({
  alunoData: {
    type: Object,
    required: true,
  },
});

const isEditarAlunoVisible = ref(false);

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
   
    <VCol cols="12">
      <VCard v-if="props.alunoData">
        <VCardText class="text-center pt-12 pb-6">
         
          <VAvatar
            rounded="lg"
            :size="120"
            :color="!props.alunoData.avatar ? 'primary' : undefined"
            :variant="!props.alunoData.avatar ? 'tonal' : undefined"
          >
            <VImg v-if="props.alunoData.avatar" :src="props.alunoData.avatar" />
            <span v-else class="text-5xl font-weight-medium">
              {{ avatarText(props.alunoData.nomeCompleto) }}
            </span>
          </VAvatar>

          <h5 class="text-h5 mt-4">
            {{ props.alunoData.nomeCompleto }}
          </h5>

          <VChip
            :color="resolveEstadoVariant(props.alunoData.estado).color"
            size="small"
            class="text-capitalize mt-4"
          >
            {{ props.alunoData.estado }}
          </VChip>
        </VCardText>

        <VCardText class="pb-6">
          <h5 class="text-h6">Detalhes do aluno</h5>

          <VDivider class="my-4" />

    
          <VList class="card-list">
            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Data de Nascimento : </span>
                <span class="text-body-1">{{
                  props.alunoData.dataNascimento
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium"
                  >Província de Nascimento :
                </span>
                <span class="text-body-1">{{
                  props.alunoData.provinciaNascimento
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium"
                  >Distrito de Nascimento :
                </span>
                <span class="text-body-1">{{
                  props.alunoData.distritoNascimento
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Data de Registo : </span>
                <span class="text-body-1">{{
                  props.alunoData.dataRegisto
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">BI : </span>
                <span class="text-body-1">{{
                  props.alunoData.bilheteIdentificacao
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Telefone : </span>
                <span class="text-body-1">{{
                  props.alunoData.numeroTelefonePrincipal
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Email : </span>
                <span class="text-body-1">{{ props.alunoData.email }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Nome do Pai : </span>
                <span class="text-body-1">{{ props.alunoData.nomeDoPai }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Nome da Mãe : </span>
                <span class="text-body-1">{{ props.alunoData.nomeDaMae }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Religião : </span>
                <span class="text-body-1">{{ props.alunoData.religiao }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Grupo Sanguíneo : </span>
                <span class="text-body-1">{{
                  props.alunoData.grupoSanguineo
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Morada : </span>
                <span class="text-body-1">{{ props.alunoData.endereco }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Escola Anterior : </span>
                <span class="text-body-1">{{
                  props.alunoData.escolaAnterior
                }}</span>
              </VListItemTitle>
            </VListItem>

            <VListItem>
              <VListItemTitle class="text-sm">
                <span class="font-weight-medium">Estado : </span>
                <span class="text-body-1">{{ props.alunoData.estado }}</span>
              </VListItemTitle>
            </VListItem>
          </VList>
        </VCardText>

     
        <VCardText class="d-flex justify-center">
          <VBtn
            variant="elevated"
            class="me-4"
            @click="isEditarAlunoVisible = true"
          >
            Editar
          </VBtn>
          <VBtn variant="outlined" color="error"> Suspender </VBtn>
        </VCardText>
      </VCard>
    </VCol>

  </VRow>

 
  <EditarEstudante
    v-model:isDialogVisible="isEditarAlunoVisible"
    :user-data="props.alunoData"
  />

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
