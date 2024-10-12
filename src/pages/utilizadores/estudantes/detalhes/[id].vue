<script setup>
import Actividades from "@/views/utilizadores/estudantes/detalhes/Actividades.vue";
import Documentacao from "@/views/utilizadores/estudantes/detalhes/Documentacao.vue";
import Frequencia from "@/views/utilizadores/estudantes/detalhes/Frequencia.vue";
import HistoricoAcademico from "@/views/utilizadores/estudantes/detalhes/HistoricoAcademico.vue";
import InformacaoFamilia from "@/views/utilizadores/estudantes/detalhes/InformacaoFamilia.vue";
import Mensalidades from "@/views/utilizadores/estudantes/detalhes/Mensalidades.vue";
import Sobre from "@/views/utilizadores/estudantes/detalhes/Sobre.vue";
import { onMounted, ref } from "vue";

const route = useRoute("utilizadores-estudantes-detalhes-id"); // Assumindo que o nome da rota é "utilizadores-estudantes-detalhes-id"
const userTab = ref(null);
const userData = ref(null); // Para armazenar os dados do aluno

const token = useCookie("accessToken").value;

const tabs = [
  {
    icon: "ri-coin-line",
    title: "Pagamentos",
    content:
      "Informações sobre os pais ou responsáveis, contacto de emergência e dados relacionados.",
  },

  {
    icon: "ri-group-line",
    title: "Encarregados",
    content:
      "Informações sobre os pais ou responsáveis, contacto de emergência e dados relacionados.",
  },

  {
    icon: "ri-book-line",
    title: "Histórico Académico",
    content:
      "Histórico escolar, disciplinas, notas, e situação académica atual.",
  },

  {
    icon: "ri-calendar-line",
    title: "Frequência",
    content: "Registros de frequência escolar, faltas e justificativas.",
  },
  {
    icon: "ri-award-line",
    title: "Actividades",
    content:
      "Participação em actividades extracurriculares, eventos escolares e prémios ou menções.",
  },
  {
    icon: "ri-file-list-line",
    title: "Documentação",
    content:
      "Documentos importantes como bilhete de identidade, certificado de matrícula e outros arquivos necessários.",
  },
  {
    icon: "ri-file-user-line",
    title: "Observações",
    content:
      "Comentários e observações de professores ou coordenadores sobre o desempenho do aluno.",
  },
];

// Função para buscar os dados do aluno
const fetchAluno = async () => {
  try {
    const res = await $api(`/alunos/aluno/${route.params.id}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    // Verifique se o resultado existe antes de preencher os dados

    if (res) {
      userData.value = {
        id: res.id,
        nomeCompleto: res.nomeCompleto,
        dataNascimento: res.dataNascimento,
        distritoNascimento: res.distritoNascimento,
        provinciaNascimento: res.provinciaNascimento,
        nomeDoPai: res.nomeDoPai,
        nomeDaMae: res.nomeDaMae,
        religiao: res.religiao,
        grupoSanguineo: res.grupoSanguineo,
        endereco: res.endereco,
        dataRegisto: res.dataRegisto,
        escolaAnterior: res.escolaAnterior,
        bilheteIdentificacao: res.bilheteIdentificacao,
        numeroTelefonePrincipal: res.numeroTelefonePrincipal,
        sexo: res.sexo,
        estado: res.estado,
      };
    } else {
      console.error("Nenhum dado de aluno encontrado.");
    }
  } catch (err) {
    console.error("Erro ao buscar aluno:", err);
  }
};

// Carregar os dados do aluno assim que o componente for montado
onMounted(() => {
  fetchAluno();
});
</script>
<template>
  <VRow v-if="userData">
    <!-- Painel de informações do aluno -->
    <VCol cols="12" md="5" lg="4">
      <Sobre :user-data="userData" />
    </VCol>

    <!-- Tabs com informações adicionais -->
    <VCol cols="12" md="7" lg="8">
      <VTabs v-model="userTab" class="v-tabs-pill">
        <VTab v-for="tab in tabs" :key="tab.icon">
          <VIcon start :icon="tab.icon" />
          <span>{{ tab.title }}</span>
        </VTab>
      </VTabs>

      <!-- Conteúdo das abas -->
      <VWindow
        v-model="userTab"
        class="mt-6 disable-tab-transition"
        :touch="false"
      >
        <VWindowItem>
          <Mensalidades />
        </VWindowItem>

        <VWindowItem>
          <InformacaoFamilia />
        </VWindowItem>

        <VWindowItem>
          <HistoricoAcademico />
        </VWindowItem>

        <VWindowItem>
          <Frequencia />
        </VWindowItem>

        <VWindowItem>
          <Actividades />
        </VWindowItem>

        <VWindowItem>
          <Documentacao />
        </VWindowItem>
      </VWindow>
    </VCol>
  </VRow>

  <!-- Alerta se o aluno não for encontrado -->
  <div v-else>
    <VAlert type="error" variant="tonal">
      Aluno com ID {{ route.params.id }} não encontrado!
    </VAlert>
  </div>
</template>
