<script setup>
import CadastrarEstudante from "@/views/utilizadores/estudantes/CadastrarAluno.vue";
import EditarEstudante from "@/views/utilizadores/estudantes/EditarAluno.vue";

const searchQuery = ref("");
const selectedDistrito = ref(null);
const selectedSexo = ref(null);
const selectedEstado = ref(null);

const itemsPerPage = ref(8);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const alunos = ref([]);
const distritos = ref([]);
const filteredAlunos = ref([]);

const total_alunos = ref(0);
const total_matriculados = ref(0);
const total_transferidos = ref(0);
const total_expulsos = ref(0);
const total_suspensos = ref(0);
const total_desistentes = ref(0);
const total_graduados = ref(0);

const isCadastrarAlunoVisible = ref(false);
const isEditarAlunoVisible = ref(false);

const mini_estatisticas = ref([
  {
    title: "Todos Alunos",
    value: total_alunos,
    desc: "Alunos cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Matriculados",
    value: total_matriculados,
    desc: "Alunos matriculados",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Transferidos",
    value: total_transferidos,
    desc: "Alunos transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Gradudados",
    value: total_graduados,
    desc: "Alunos cadastrados",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Desistentes",
    value: total_desistentes,
    desc: "Alunos matriculados",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Suspensos",
    value: total_suspensos,
    desc: "Alunos transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
  {
    title: "Expulsos",
    value: total_expulsos,
    desc: "Alunos transferidos",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
]);

const headers = [
  { title: "Aluno", key: "id", sortable: true },
  { title: "Nome Completo", key: "nome", sortable: true },
  { title: "Data Nascimento", key: "dataNascimento", sortable: true },
  { title: "Provincia", key: "provinciaNascimento", sortable: true },
  { title: "Distrito", key: "distritoNascimento", sortable: true },
  { title: "Sexo", key: "sexo", sortable: true },
  { title: "Nº documento", key: "bilheteIdentificacao", sortable: true },
  { title: "Nº Telefone", key: "numeroTelefonePrincipal", sortable: true },
  { title: "Estado", key: "estado", sortable: true },
  { title: "Ações", key: "actions", sortable: false },
];

const sexo = [
  { title: "Masculino", value: "Masculino" },
  { title: "Feminino", value: "Feminino" },
];

const estado = [
  { title: "Matriculado", value: "Matriculado" },
  { title: "Transferido", value: "Transferido" },
  { title: "Graduado", value: "Graduado" },
  { title: "Suspenso", value: "Suspenso" },
  { title: "Expulso", value: "Expulso" },
  { title: "Desistente", value: "Desistente" },
];

const paginatedAlunos = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredAlunos.value.slice(start, end);
});

const fetchDistritos = async () => {
  try {
    const res = await $api("/distritos", {
      method: "GET",
    });

    distritos.value = res.map((distrito) => ({
      id: distrito.id,
      nome: distrito.nome,
      provincia: distrito.provincia,
    }));

    filterAlunos();
    distritos.value = distritos.value.map((distrito) => ({
      title: distrito.nome,
      value: distrito.nome,
    }));
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const fetchAlunos = async () => {
  try {
    const res = await $api("/alunos", {
      method: "GET",
     
    });

    alunos.value = res.map((aluno) => ({
      id: aluno.id,
      nome: aluno.nomeCompleto,
      dataNascimento: aluno.dataNascimento,
      distritoNascimento: aluno.distritoNascimento,
      provinciaNascimento: aluno.provinciaNascimento,
      bilheteIdentificacao: aluno.bilheteIdentificacao,
      numeroTelefonePrincipal: aluno.numeroTelefonePrincipal,
      sexo: aluno.sexo,
      estado: aluno.estado,
    }));

    filterAlunos();
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const filterAlunos = () => {
  filteredAlunos.value = alunos.value.filter((aluno) => {
    const matchesSearch =
      aluno.nome.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      aluno.distritoNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      aluno.bilheteIdentificacao
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      aluno.dataNascimento
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      aluno.estado.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      aluno.sexo.toLowerCase().includes(searchQuery.value.toLowerCase());

    const matchesDistrito =
      !selectedDistrito.value ||
      aluno.distritoNascimento === selectedDistrito.value;
    const matchesEstado =
      !selectedEstado.value || aluno.estado === selectedEstado.value;
    const matchesSexo =
      !selectedSexo.value || aluno.sexo === selectedSexo.value;

    return matchesSearch && matchesDistrito && matchesEstado && matchesSexo;
  });
};

const totalAlunos = async () => {
  try {
    const res = await $api("/alunos/totais", {
      method: "GET",
    });

    total_alunos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};


const cadastrarAluno = async (userData) => {
  await $api("/alunos/cadastrar", {
    method: "POST",
    body: userData,
  });

  fetchAlunos();
};


const totalMatriculados = async () => {
  try {
    const res = await $api("/alunos/estado/Matriculado", {
      method: "GET",
    });

    total_matriculados.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totaTransferidos = async () => {
  try {
    const res = await $api("/alunos/estado/Transferido", {
      method: "GET",
    });

    total_transferidos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totalGradudados = async () => {
  try {
    const res = await $api("/alunos/estado/Graduado", {
      method: "GET",
    });

    total_graduados.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totalDesistentes = async () => {
  try {
    const res = await $api("/alunos/estado/Desistente", {
      method: "GET",
    });

    total_desistentes.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totalSuspensos = async () => {
  try {
    const res = await $api("/alunos/estado/Suspenso", {
      method: "GET",
    });

    total_suspensos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const totalExpulsos = async () => {
  try {
    const res = await $api("/alunos/estado/Expulso", {
      method: "GET",
    });

    total_expulsos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

watch(
  [searchQuery, selectedDistrito, selectedSexo, selectedEstado],
  filterAlunos
);

const atualizarDados = () => {
  fetchAlunos();
  totalAlunos();
  totaTransferidos();
  totalMatriculados();
  totalGradudados();
  totalExpulsos();
  totalSuspensos();
  totalDesistentes();
  fetchDistritos();
  
};

atualizarDados();
</script>

<template>
  <section>
    <div class="d-flex mb-6">
      <VRow>
        <template v-for="data in mini_estatisticas" :key="id">
          <VCol cols="12" md="3" sm="6">
            <VCard>
              <VCardText>
                <div class="d-flex justify-space-between">
                  <div class="d-flex flex-column gap-y-1">
                    <span class="text-base text-high-emphasis">{{
                      data.title
                    }}</span>
                    <h4 class="text-h4 d-flex align-center gap-2">
                      {{ data.value }}
                    </h4>
                    <p class="text-sm mb-0">{{ data.desc }}</p>
                  </div>
                  <VAvatar
                    :color="data.iconColor"
                    variant="tonal"
                    rounded
                    size="42"
                  >
                    <VIcon :icon="data.icon" size="26" />
                  </VAvatar>
                </div>
              </VCardText>
            </VCard>
          </VCol>
        </template>
      </VRow>
    </div>

    <VCard class="mb-6">
      <VCardItem class="pb-4">
        <VCardTitle>Filtrar Alunos</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VAutocomplete
              v-model="selectedDistrito"
              label="Seleccionar o distrito de nascenca"
              placeholder="Seleccionar tipo de Utilizador"
              :items="distritos"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedSexo"
              label="Selecionar Sexo"
              placeholder="Escolher Sexo"
              :items="sexo"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedEstado"
              label="Selecionar Estado"
              placeholder="Escolher Estado"
              :items="estado"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
        </VRow>
      </VCardText>
      <VDivider />

      <VCardText class="d-flex flex-wrap gap-4 align-center">
        <VBtn
          variant="outlined"
          color="secondary"
          prepend-icon="ri-refresh-fill"
          @click="atualizarDados()"
          >Recarregar Dados</VBtn
        >
        <VSpacer />
        <div class="d-flex align-center gap-4 flex-wrap">
          <div class="app-user-search-filter">
            <VTextField
              v-model="searchQuery"
              placeholder="Buscar aluno"
              density="compact"
            />
          </div>

          <VBtn @click="isCadastrarAlunoVisible = true">Cadastrar Aluno</VBtn>
        </div>
      </VCardText>
    </VCard>
    <VCard class="mb-6">
      <VDataTableServer
        v-model:model-value="selectedRows"
        :items="paginatedAlunos"
        item-value="id"
        :items-per-page="itemsPerPage"
        :items-length="filteredAlunos.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
        <template #item.actions="{ item }">
          <IconBtn
            size="small"
            :to="{
              name: 'utilizadores-alunos-detalhes-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <VBtn
            icon="ri-edit-2-line"
            :icon-color="success"
            variant="plain"
            @click="isEditarAlunoVisible = true"
          />
        </template>
      </VDataTableServer>
    </VCard>
    <!-- Cadastrar estudante modal -->
    <CadastrarEstudante
      v-model:isDrawerOpen="isCadastrarAlunoVisible"
      @user-data="cadastrarAluno"
    />

    <EditarEstudante
      v-model:isDrawerOpen="isCadastrarAlunoVisible"
      @user-data="cadastrarAluno"
    />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
