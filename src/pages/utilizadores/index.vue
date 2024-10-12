<script setup>
import CadastrarUtilizador from "@/views/utilizadores/list/AddNewUserDrawer.vue";

const searchQuery = ref("");
const roleEscolhido = ref(null);
const selectedPlan = ref(null);
const estadoEscolhido = ref(null);

const snackbar = ref(false);
const snackbarMessage = ref("");
const snackbarColor = ref("success");

const itemsPerPage = ref(5);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const utilizadores = ref([]);
const user = ref([]);
const roles = ref([]);
const filteredUtilizadores = ref([]);
const total_users = ref(0);
const total_estudantes = ref(0);
const total_professores = ref(0);
const total_funcionarios = ref(0);
const token = useCookie("accessToken").value;

const updateOptions = (options) => {
  page.value = options.page;
  sortBy.value = options.sortBy[0]?.key;
  orderBy.value = options.sortBy[0]?.order;
};

const headers = [
  { title: "Nome Completo", key: "nome" },
  { title: "Username", key: "username" },
  { title: "Email", key: "email" },
  { title: "Tipo de Utilizador", key: "roles", sortable: false },
  { title: "Ações", key: "actions", sortable: false },
];

const buscarRoles = async () => {
  try {
    const res = await $api("/roles", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Passar o token corretamente
      },
    });

    roles.value = res.map((role) => ({
      id: role.id,
      name: role.name,
    }));

    filtrarUtilizadores();
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const buscarUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Passar o token corretamente
      },
    });

    utilizadores.value = res.map((utilizador) => ({
      id: utilizador.id,
      nome: utilizador.nome,
      username: utilizador.username,
      email: utilizador.email,
      roles: utilizador.role,
      status: utilizador.status,
      sexo: utilizador.sexo,
    }));

    filtrarUtilizadores();
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const filtrarUtilizadores = () => {
  filteredUtilizadores.value = utilizadores.value.filter((utilizador) => {
    const matchesSearch =
      utilizador.nome.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      utilizador.username
        .toLowerCase()
        .includes(searchQuery.value.toLowerCase()) ||
      utilizador.email.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesRole =
      !roleEscolhido.value || utilizador.roles.includes(roleEscolhido.value);
    const matchesStatus =
      !estadoEscolhido.value || utilizador.status === estadoEscolhido.value;
    const matchesSexo =
      !selectedPlan.value || utilizador.sexo === selectedPlan.value;

    return matchesSearch && matchesRole && matchesStatus && matchesSexo;
  });
};

watch(
  [searchQuery, roleEscolhido, selectedPlan, estadoEscolhido],
  filtrarUtilizadores
);

const totalUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores/totais", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    total_users.value = res;
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const atualizarDados = () => {
  buscarUtilizadores();
  totalUtilizadores();
  buscarRoles();
};

const deleteUser = async (id) => {
  try {
    const response = await $api(`/utilizadores/remover/${id}`, {
      method: "DELETE",
    });

    if (response === 200) {
      // Sucesso ao deletar o usuário
      const index = selectedRows.value.findIndex((row) => row.id === id);
      if (index !== -1) selectedRows.value.splice(index, 1);
      snackbarMessage.value = "Usuário deletado com sucesso!";
      snackbarColor.value = "success";
    } else {
      // Caso a resposta não seja bem-sucedida
      snackbarMessage.value = "Erro ao deletar o usuário!";
      snackbarColor.value = "error";
    }
  } catch (error) {
    // Erro ao fazer a requisição
    snackbarMessage.value = "Erro ao conectar ao servidor!";
    snackbarColor.value = "error";
  } finally {
    snackbar.value = true; // Exibe o snackbar
    atualizarDados(); // Atualiza os dados após a operação
  }
};

const widgetData = ref([
  {
    title: "Utilizadores Cadastrados",
    value: total_users,
    desc: "Todos Utilizadores do Sistema",
    icon: "ri-group-line",
    iconColor: "primary",
  },
  {
    title: "Estudantes",
    value: total_estudantes,
    desc: "Estudantes Cadastrados",
    icon: "ri-user-add-line",
    iconColor: "error",
  },
  {
    title: "Professores",
    value: total_professores,
    desc: "Membros do corpo docente",
    icon: "ri-user-follow-line",
    iconColor: "success",
  },
  {
    title: "Funcionarios",
    value: total_funcionarios,
    desc: "Outros Funcionarios da Escole",
    icon: "ri-user-search-line",
    iconColor: "warning",
  },
]);

const isCadastrarUserVisible = ref(false);

const cadastrarUtilizador = async (userData) => {
  await $api("/cadastro", {
    method: "POST",
    body: userData,
  });

  snackbarMessage.value = "Utilizador cadastrado com sucesso!";
  snackbarColor.value = "success";
  snackbar.value = true;

  atualizarDados();
};

atualizarDados();
</script>

<template>
  <section>
    <VSnackbar
      v-model="snackbar"
      color="snackbarColor"
      timeout="3000"
      top
      multi-line
      vertical
    >
      {{ snackbarMessage }}
      <template #action>
        <VBtn color="white" text @click="snackbar = false">Fechar</VBtn>
      </template>
    </VSnackbar>
    <div class="d-flex mb-6">
      <VRow>
        <template v-for="(data, id) in widgetData" :key="id">
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
        <VCardTitle>Filtrar utilizadores</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <VCol cols="12" sm="4">
            <VSelect
              v-model="roleEscolhido"
              label="Seleccionar o tipo de Utilizador"
              placeholder="Seleccionar tipo de Utilizador"
              :items="roles"
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
              placeholder="Buscar utilizador"
              density="compact"
            />
          </div>

          <VBtn @click="isCadastrarUserVisible = true"
            >Cadastrar Utilizador</VBtn
          >
        </div>
      </VCardText>

      <VDataTableServer
        v-model:model-value="selectedRows"
        v-model:items-per-page="itemsPerPage"
        v-model:page="page"
        :items="filteredUtilizadores"
        item-value="id"
        :items-length="filteredUtilizadores.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
        <template #item.roles="{ item }">
          <VChip v-for="(role, index) in item.roles" :key="index">
            {{ role.name }}
          </VChip>
        </template>

        <template #item.actions="{ item }">
          <!-- Verifica se ROLE_ESTUDANTE está presente nos roles -->

          <IconBtn
            size="small"
            v-if="item.roles.includes('ROLE_ESTUDANTE')"
            :to="{
              name: 'utilizadores-estudantes-detalhes-id',
              params: { id: item.id },
            }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <IconBtn
            size="small"
            v-else
            :to="{ name: 'utilizadores-detalhes-id', params: { id: item.id } }"
          >
            <VIcon icon="ri-eye-line" />
          </IconBtn>

          <IconBtn size="small" @click="deleteUser(item.id)" style="color: red;">
            <VIcon icon="ri-delete-bin-5-line" />
          </IconBtn>
        </template>
      </VDataTableServer>
    </VCard>

    <CadastrarUtilizador
      v-model:isDrawerOpen="isCadastrarUserVisible"
      @user-data="cadastrarUtilizador"
    />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
