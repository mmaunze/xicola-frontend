<script setup>
const props = defineProps({
  userData: {
    type: Object,
    required: false,
    default: () => ({
      avatar: '',
      nomeCompleto: '',
      dataNascimento: '',
      distritoNascimento: '',
      provinciaNascimento: '',
      nomeDoPai: '',
      nomeDaMae: '',
      religiao: '',
      grupoSanguineo: '',
      endereco: '',
      dataRegisto: '',
      escolaAnterior: '',
      bilheteIdentificacao: '',
      numeroTelefonePrincipal: '',
      sexo: '',
      estado: '',
    }),
  },
  isDialogVisible: {
    type: Boolean,
    required: true,
  },
})

const emit = defineEmits([
  'submit',
  'update:isDialogVisible',
])

const userData = ref(structuredClone(toRaw(props.userData)))

watch(() => props, () => {
  userData.value = structuredClone(toRaw(props.userData))
})

const onFormSubmit = () => {
  emit('update:isDialogVisible', false)
  emit('submit', userData.value)
}

const onFormReset = () => {
  userData.value = structuredClone(toRaw(props.userData))
  emit('update:isDialogVisible', false)
}

const dialogVisibleUpdate = val => {
  emit('update:isDialogVisible', val)
}
</script>

<template>
  <VDialog
    :width="$vuetify.display.smAndDown ? 'auto' : 900"
    :model-value="props.isDialogVisible"
    @update:model-value="dialogVisibleUpdate"
  >
    <VCard class="pa-sm-11 pa-3">
      <!-- Dialog close button -->
      <DialogCloseBtn
        variant="text"
        size="default"
        @click="onFormReset"
      />

      <VCardText class="pt-5">
        <div class="text-center pb-6">
          <h4 class="text-h4 mb-2">
            Editar Informações do Aluno
          </h4>
          <div class="text-body-1">
            As actualizações nas informações do aluno serão auditadas.
          </div>
        </div>

        <!-- Form -->
        <VForm
          class="mt-4"
          @submit.prevent="onFormSubmit"
        >
          <VRow>
            <!-- Nome Completo -->
            <VCol cols="12">
              <VTextField
                v-model="userData.nomeCompleto"
                label="Nome Completo"
                placeholder="Ex: João Silva"
              />
            </VCol>

            <!-- Data de Nascimento -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.dataNascimento"
                label="Data de Nascimento"
                placeholder="Ex: 01/01/2000"
              />
            </VCol>

            <!-- Sexo -->
            <VCol cols="12" md="6">
              <VSelect
                v-model="userData.sexo"
                :items="['Masculino', 'Feminino']"
                label="Sexo"
                placeholder="Selecione o sexo"
              />
            </VCol>

            <!-- Nome do Pai -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.nomeDoPai"
                label="Nome do Pai"
                placeholder="Ex: José Silva"
              />
            </VCol>

            <!-- Nome da Mãe -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.nomeDaMae"
                label="Nome da Mãe"
                placeholder="Ex: Maria Silva"
              />
            </VCol>

            <!-- Distrito de Nascimento -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.distritoNascimento"
                label="Distrito de Nascimento"
                placeholder="Ex: Lisboa"
              />
            </VCol>

            <!-- Província de Nascimento -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.provinciaNascimento"
                label="Província de Nascimento"
                placeholder="Ex: Lisboa"
              />
            </VCol>

            <!-- Grupo Sanguíneo -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.grupoSanguineo"
                label="Grupo Sanguíneo"
                placeholder="Ex: O+"
              />
            </VCol>

            <!-- Religião -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.religiao"
                label="Religião"
                placeholder="Ex: Católica"
              />
            </VCol>

            <!-- Bilhete de Identificação -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.bilheteIdentificacao"
                label="Bilhete de Identificação"
                placeholder="Ex: 123456789"
              />
            </VCol>

            <!-- Número de Telefone -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.numeroTelefonePrincipal"
                label="Número de Telefone"
                placeholder="Ex: +351 912345678"
              />
            </VCol>

            <!-- Endereço -->
            <VCol cols="12">
              <VTextField
                v-model="userData.endereco"
                label="Endereço"
                placeholder="Ex: Rua ABC, 123, Lisboa"
              />
            </VCol>

            <!-- Escola Anterior -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.escolaAnterior"
                label="Escola Anterior"
                placeholder="Ex: Escola Secundária ABC"
              />
            </VCol>

            <!-- Data de Registo -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.dataRegisto"
                label="Data de Registo"
                placeholder="Ex: 01/09/2020"
              />
            </VCol>

            <!-- Estado -->
            <VCol cols="12" md="6">
              <VSelect
                v-model="userData.estado"
                :items="['Activo', 'Inactivo', 'Expulso']"
                label="Estado"
                placeholder="Estado actual"
              />
            </VCol>

            <!-- Submit and Cancel -->
            <VCol
              cols="12"
              class="d-flex flex-wrap justify-center gap-4"
            >
              <VBtn type="submit">
                Submeter
              </VBtn>

              <VBtn
                color="secondary"
                variant="outlined"
                @click="onFormReset"
              >
                Cancelar
              </VBtn>
            </VCol>
          </VRow>
        </VForm>
      </VCardText>
    </VCard>
  </VDialog>
</template>
