<script setup>
import Actividades from "@/views/utilizadores/professores/detalhes/Actividades.vue";
import Documentacao from "@/views/utilizadores/professores/detalhes/Documentacao.vue";
import Frequencia from "@/views/utilizadores/professores/detalhes/Frequencia.vue";
import HistoricoAcademico from "@/views/utilizadores/professores/detalhes/HistoricoAcademico.vue";
import InformacaoFamilia from "@/views/utilizadores/professores/detalhes/InformacaoFamilia.vue";
import Mensalidades from "@/views/utilizadores/professores/detalhes/Mensalidades.vue";
import Sobre from "@/views/utilizadores/professores/detalhes/Sobre.vue";
import { onMounted, ref } from "vue";

const route = useRoute("utilizadores-professores-detalhes-id"); 
const userTab = ref(null);
const userData = ref(null); 

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


const fetchProfessor = async () => {
  try {
    const res = await $api(`/professores/professor/${route.params.id}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

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
        dataRegisto: res.dataContracto,
        escolaAnterior: res.escolaAnterior,
        estadoCivil: res.estadoCivil,
        areaFormacao: res.areaFormacao,
        bilheteIdentificacao: res.bilheteIdentificacao,
        numeroTelefonePrincipal: res.numeroTelefonePrincipal,
        numerroTelefoneAlternativo: res.numerroTelefoneAlternativo,
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


onMounted(() => {
  fetchProfessor();
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


  <div v-else>
    <VAlert type="error" variant="tonal">
      Professor {{ route.params.id }} não encontrado!
    </VAlert>
  </div>
</template>
