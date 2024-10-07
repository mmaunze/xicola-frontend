<script setup>
import AddNewUserDrawer from "@/views/utilizadores/list/AddNewUserDrawer.vue";

// 👉 Store
const searchQuery = ref("");
const roleEscolhido = ref(null);
const selectedPlan = ref(null);
const estadoEscolhido = ref(null);

const snackbar = ref(false); // Controla a visibilidade da snackbar
const snackbarMessage = ref(""); // Armazena a mensagem a ser exibida
const snackbarColor = ref("success"); // Controla a cor da snackbar (success, error, etc.)


// Data table options
const itemsPerPage = ref(5);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const utilizadores = ref([]);
const filteredUtilizadores = ref([]); // Utilizadores filtrados
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

// Headers
const headers = [
  { title: "Nome Completo", key: "nome" },
  { title: "Username", key: "username" },
  { title: "Email", key: "email" },
  { title: "Tipo de Utilizador", key: "roles", sortable: false },
  { title: "Ações", key: "actions", sortable: false },
];

// 👉 search filters
const roles = [
  { title: "ROLE_ESTUDANTE", value: "ROLE_ESTUDANTE" },
  { title: "Professor", value: "ROLE_PROFESSOR" },
  { title: "Pegagogico", value: "ROLE_PEDAGOGICO" },
  { title: "Financeiro", value: "ROLE_FINANCEIRO" },
  { title: "Encarregado", value: "ROLE_encarregado" },
];

const sexo = [
  { title: "Masculino", value: "m" },
  { title: "Feminino", value: "f" },
];

const estado = [
  { title: "Pending", value: "Pending" },
  { title: "Activo", value: "Active" },
  { title: "Desactivado", value: "Inactive" },
];

// Função para buscar utilizadores da API
const buscarUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Passar o token corretamente
      },
    });

    utilizadores.value = res.map((user) => ({
      id: user.id,
      nome: user.nome,
      username: user.username,
      email: user.email,
      roles: user.role,
      status: user.status,  // Adicionei status
      sexo: user.sexo       // Adicionei sexo
    }));

    filtrarUtilizadores();  // Aplicar filtros automaticamente
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

// Função para filtrar os utilizadores com base nos filtros aplicados
const filtrarUtilizadores = () => {
  filteredUtilizadores.value = utilizadores.value.filter((user) => {
    const matchesSearch = user.nome.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                          user.email.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesRole = !roleEscolhido.value || user.roles.includes(roleEscolhido.value);
    const matchesStatus = !estadoEscolhido.value || user.status === estadoEscolhido.value;
    const matchesSexo = !selectedPlan.value || user.sexo === selectedPlan.value;

    return matchesSearch && matchesRole && matchesStatus && matchesSexo;
  });
};

// Observers para aplicar os filtros sempre que um valor mudar
watch([searchQuery, roleEscolhido, selectedPlan, estadoEscolhido], filtrarUtilizadores);

// Função para obter o total de utilizadores
const totalUtilizadores = async () => {
  try {
    const res = await $api("/utilizadores/totais", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Passar o token corretamente
      },
    });

    total_users.value = res;
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

// Função para atualizar os dados ao recarregar
const atualizarDados = () => {
  buscarUtilizadores();
  totalUtilizadores();
};

// Função para remover um utilizador
const deleteUser = async (id) => {
  await $api(`/utilizadores/remover/${id}`, { method: "DELETE" });

  const index = selectedRows.value.findIndex((row) => row === id);
  if (index !== -1) selectedRows.value.splice(index, 1);

  atualizarDados();
};

const widgetData = ref([
  {
    title: "Usuarios Cadastrados",
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
  // userListStore.addUser(userData)
  await $api("/autenticacao/cadastro", {
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
    timeout="3000" <!-- Duração da notificação em milissegundos -->
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
                    <span class="text-base text-high-emphasis">{{ data.title }}</span>
                    <h4 class="text-h4 d-flex align-center gap-2">{{ data.value }}</h4>
                    <p class="text-sm mb-0">{{ data.desc }}</p>
                  </div>
                  <VAvatar :color="data.iconColor" variant="tonal" rounded size="42">
                    <VIcon :icon="data.icon" size="26" />
                  </VAvatar>
                </div>
              </VCardText>
            </VCard>
          </VCol>
        </template>
      </VRow>
    </div>

    <!-- Filtros -->
    <VCard class="mb-6">
      <VCardItem class="pb-4">
        <VCardTitle>Filtrar utilizadores</VCardTitle>
      </VCardItem>
      <VCardText>
        <VRow>
          <!-- Select Role -->
          <VCol cols="12" sm="4">
            <VSelect v-model="roleEscolhido" label="Seleccionar o tipo de Utilizador" placeholder="Seleccionar tipo de Utilizador" :items="roles" clearable clear-icon="ri-close-line" />
          </VCol>
          <!-- Select Sexo -->
          <VCol cols="12" sm="4">
            <VSelect v-model="selectedPlan" label="Selecionar Sexo" placeholder="Escolher Sexo" :items="sexo" clearable clear-icon="ri-close-line" />
          </VCol>
          <!-- Select Status -->
          <VCol cols="12" sm="4">
            <VSelect v-model="estadoEscolhido" label="Seleccionar estado" placeholder="Seleccionar estado" :items="estado" clearable clear-icon="ri-close-line" />
          </VCol>
        </VRow>
      </VCardText>

      <VDivider />

      <VCardText class="d-flex flex-wrap gap-4 align-center">
        <VBtn variant="outlined" color="secondary" prepend-icon="ri-download-2-line" @click="atualizarDados()">Recarregar Dados</VBtn>
        <VSpacer />
        <div class="d-flex align-center gap-4 flex-wrap">
          <!-- Search -->
          <div class="app-user-search-filter">
            <VTextField v-model="searchQuery" placeholder="Buscar utilizador" density="compact" />
          </div>
          <!-- Add User Button -->
          <VBtn @click="isCadastrarUserVisible = true">Cadastrar Utilizador</VBtn>
        </div>
      </VCardText>

      <!-- DataTable -->
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
        <!-- Colunas Personalizadas -->
        <template #item.nome="{ item }">
          <div class="d-flex flex-column">
            <span>{{ item.nome }}</span>
          </div>
        </template>

        <template #item.username="{ item }">
          <div class="d-flex flex-column">
            <span>{{ item.username }}</span>
          </div>
        </template>

        <template #item.email="{ item }">
          <div class="d-flex flex-column">
            <span>{{ item.email }}</span>
          </div>
        </template>

        <template #item.roles="{ item }">
          <VChip v-for="(role, index) in item.roles" :key="index">
            {{ role.name }}
          </VChip>
        </template>

        <!-- Ações -->
        <template #item.actions="{ item }">
          <IconBtn size="small" @click="deleteUser(item.id)">
            <VIcon icon="ri-delete-bin-7-line" />
          </IconBtn>
        </template>
      </VDataTableServer>
    </VCard>

    <!-- Add New User Drawer -->
    <AddNewUserDrawer v-model:isDrawerOpen="isCadastrarUserVisible" @user-data="cadastrarUtilizador" />
  </section>
</template>

<style lang="scss" scoped>
.app-user-search-filter {
  inline-size: 15.625rem;
}
</style>
