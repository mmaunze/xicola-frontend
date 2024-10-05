<script setup>
import AddNewUserDrawer from "@/views/utilizadores/list/AddNewUserDrawer.vue";

// 👉 Store
const searchQuery = ref("");
const selectedRole = ref();
const selectedPlan = ref();
const selectedStatus = ref();

// Data table options
const itemsPerPage = ref(5);
const page = ref(1);
const sortBy = ref();
const orderBy = ref();
const selectedRows = ref([]);
const utilizadores = ref([]);
const total_users = ref(0);
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
  {
    title: "Estudante",
    value: "ROLE_ESTUDANTE",
  },
  {
    title: "Professor",
    value: "ROLE_PROFESSOR",
  },
  {
    title: "Pegagogico",
    value: "ROLE_PEDAGOGICO",
  },
  {
    title: "Financeiro",
    value: "ROLE_FINANCEIRO",
  },
  {
    title: "Encarregado",
    value: "ROLE_encarregado",
  },
];

const sexo = [
  {
    title: "Masuclino",
    value: "m",
  },
  {
    title: "Feminino",
    value: "f",
  },
];

const estado = [
  {
    title: "Pending",
    value: "Pending",
  },
  {
    title: "Activo",
    value: "Active",
  },
  {
    title: "Desactivado",
    value: "Inactive",
  },
];

const resolveUserRoleVariant = (role) => {
  const roleLowerCase = role.toLowerCase();
  if (roleLowerCase === "role_estudante")
    return {
      color: "success",
      icon: "ri-user-line",
    };
  if (roleLowerCase === "role_professor")
    return {
      color: "error",
      icon: "ri-computer-line",
    };
  if (roleLowerCase === "role_pedagogico")
    return {
      color: "info",
      icon: "ri-pie-chart-line",
    };
  if (roleLowerCase === "role_financeiro")
    return {
      color: "warning",
      icon: "ri-edit-box-line",
    };
  if (roleLowerCase === "role_encarregado")
    return {
      color: "primary",
      icon: "ri-vip-crown-line",
    };

  return {
    color: "success",
    icon: "ri-user-line",
  };
};

const atualizarDados = () => {
  fetchUsers();
  totalUsers();
};
// Função para buscar utilizadores da API
const fetchUsers = async () => {
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
    }));
  } catch (err) {
    console.error("Erro ao buscar utilizadores:", err);
  }
};

const totalUsers = async () => {
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

const resolveUserStatusVariant = (stat) => {
  const statLowerCase = stat.toLowerCase();
  if (statLowerCase === "pending") return "warning";
  if (statLowerCase === "active") return "success";
  if (statLowerCase === "inactive") return "secondary";

  return "primary";
};





const deleteUser = async (id) => {
  await $api(`/utilizadores/remover/${id}`, { method: "DELETE" });

  // Delete from selectedRows
  const index = selectedRows.value.findIndex((row) => row === id);
  if (index !== -1) selectedRows.value.splice(index, 1);

  // Refetch User
  fetchUsers();
};



atualizarDados();
</script>

<template>
  <section>
    <!-- 👉 Widgets -->
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

                    <p class="text-sm mb-0">
                      {{ data.desc }}
                    </p>
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
          <!-- 👉 Select Role -->
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedRole"
              label="Seleccionar o tipo de Utilizador"
              placeholder="Seleccionar tipo de Utilizador"
              :items="roles"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <!-- 👉 Select Plan -->
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedPlan"
              label="Selecccionar sexo"
              placeholder="Escolher Sexo"
              :items="sexo"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
          <!-- 👉 Select Status -->
          <VCol cols="12" sm="4">
            <VSelect
              v-model="selectedStatus"
              label="Seleccionar estado"
              placeholder="Seleccionar estado"
              :items="estado"
              clearable
              clear-icon="ri-close-line"
            />
          </VCol>
        </VRow>
      </VCardText>

      <VDivider />

      <VCardText class="d-flex flex-wrap gap-4 align-center">
        <!-- 👉 Export button -->
        <VBtn
          variant="outlined"
          color="secondary"
          prepend-icon="ri-download-2-line"
          @click="atualizarDados()"
        >
          Recarregar Dados
        </VBtn>
        <VSpacer />
        <div class="d-flex align-center gap-4 flex-wrap">
          <!-- 👉 Search  -->
          <div class="app-user-search-filter">
            <VTextField
              v-model="searchQuery"
              placeholder="Buscar utilizador"
              density="compact"
            />
          </div>
          <!-- 👉 Add user button -->
          <VBtn @click="isCadastrarUserVisible = true"
            >Cadastrar Utilizador</VBtn
          >
        </div>
      </VCardText>

      <!-- SECTION datatable -->
      <VDataTableServer
        v-model:model-value="selectedRows"
        v-model:items-per-page="itemsPerPage"
        v-model:page="page"
        :items="utilizadores"
        item-value="id"
        :items-length="utilizadores.length"
        :headers="headers"
        show-select
        class="text-no-wrap rounded-0"
        @update:options="updateOptions"
      >
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

        <!-- Exibir Roles -->
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
          <IconBtn size="small" @click="deleteUser(item.id)">
            <VIcon icon="ri-delete-bin-7-line" />
          </IconBtn>
        </template>
      </VDataTableServer>

      <!-- SECTION -->
    </VCard>
    <!-- 👉 Add New User -->
    <AddNewUserDrawer
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
