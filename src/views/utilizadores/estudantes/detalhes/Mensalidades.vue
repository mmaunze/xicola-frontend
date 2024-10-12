<script setup>
import CadastrarEstudante from "@/views/utilizadores/estudantes/CadastrarEstudante.vue";

const searchQuery = ref("");
const selectedDistrito = ref(null);
const selectedSexo = ref(null);
const selectedEstado = ref(null);

const itemsPerPage = ref(5);
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
const token = useCookie("accessToken").value;

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

const headers = [
  { title: "Aluno", key: "id", sortable: true },
  { title: "Nome Completo", key: "nome", sortable: true },
  { title: "Data Nascimento", key: "dataNascimento", sortable: true },
  { title: "Distrito", key: "distritoNascimento", sortable: true },
  { title: "Sexo", key: "sexo", sortable: true },
  { title: "Nº documento", key: "bilheteIdentificacao", sortable: true },
  { title: "Nº Telefone", key: "numeroTelefonePrincipal", sortable: true },
  { title: "Estado", key: "estado", sortable: true },
  { title: "Ações", key: "actions", sortable: false },
];

const fetchDistritos = async () => {
  try {
    const res = await $api("/distritos", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Passar o token corretamente
      },
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

const sexo = [
  { title: "Masculino", value: "M" },
  { title: "Feminino", value: "F" },
];

fetchDistritos();

const estado = [
  { title: "Matriculado", value: "Matriculado" },
  { title: "Transferido", value: "Transferido" },
  { title: "Graduado", value: "Graduado" },
  { title: "Suspenso", value: "Suspenso" },
  { title: "Expulso", value: "Expulso" },
  { title: "Desistente", value: "Desistente" },
];

const fetchAlunos = async () => {
  try {
    const res = await $api("/alunos", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    alunos.value = res.map((aluno) => ({
      id: aluno.id,
      nome: aluno.nomeCompleto,
      dataNascimento: aluno.dataNascimento,
      distritoNascimento: aluno.distritoNascimento,
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

const paginatedAlunos = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredAlunos.value.slice(start, end);
});

watch(
  [searchQuery, selectedDistrito, selectedSexo, selectedEstado],
  filterAlunos
);

const totalAlunos = async () => {
  try {
    const res = await $api("/alunos/totais", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    total_alunos.value = res;
  } catch (err) {
    console.error("Erro ao buscar alunos:", err);
  }
};

const atualizarDados = () => {
  fetchAlunos();
  totalAlunos();
};

const deleteAluno = async (id) => {
  await $api(`/alunos/remover/${id}`, { method: "DELETE" });

  const index = selectedRows.value.findIndex((row) => row === id);
  if (index !== -1) selectedRows.value.splice(index, 1);

  fetchAlunos();
};

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
]);

const isCadastrarAlunoVisible = ref(false);

const cadastrarAluno = async (userData) => {
  await $api("/autenticacao/cadastro", {
    method: "POST",
    body: userData,
  });

  fetchAlunos();
};

atualizarDados();
</script>

<template>
  <section>
    <div class="d-flex mb-6">
      <VRow>
        <template v-for="data in mini_estatisticas" :key="id">
          <VCol cols="12" md="4" sm="6">
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
          prepend-icon="ri-refresh-line"
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
              name: 'utilizadores-estudantes-detalhes-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <VBtn
            icon="ri-edit-2-line"
            :icon-color="success"
            variant="plain"
            @click="isCadastrarAlunoVisible = true"
          />
        </template>
      </VDataTableServer>
    </VCard>
    <!-- Cadastrar estudante modal -->
    <CadastrarEstudante
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
