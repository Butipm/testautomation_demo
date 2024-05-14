package automation;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ExamplesTest {

    @Test
    public void testParallel() {
        Results results = Runner.path("classpath:automation/tests")
            .outputCucumberJson(true)
            .backupReportDir(false)
            .outputJunitXml(true)
            .parallel(1);

        generateReport(results.getReportDir());

        ConsolidateJsonFilesInFolder();

        if (results.getFailCount() > 0) {
            throw new AssertionError("There are test failures. Failing Maven build.");
        }
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "MDD_TestAutomation");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

    @Test
    public void ConsolidateJsonFilesInFolder() {
        String projectFolderPath = "target/karate-reports";
        String mavenPropertiesTag = extractMavenPropertiesTag(System.getProperty("karate.options"));

        ArrayNode consolidatedArray = readAndConsolidateJsonFiles(projectFolderPath, mavenPropertiesTag);

        writeConsolidatedJsonToFile(consolidatedArray, mavenPropertiesTag);
    }

    private static String extractMavenPropertiesTag(String karateOptions) {
        Pattern pattern = Pattern.compile("--tags\\s*@([^\\s\"]+)");
        Matcher matcher = pattern.matcher(karateOptions);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null; // Return null if no match is found
    }

    private static ArrayNode readAndConsolidateJsonFiles(String folderPath, String mavenPropertiesTag) {
        ArrayNode consolidatedArray = new ObjectMapper().createArrayNode();

        File folder = new File(folderPath);
        File[] jsonFiles = folder.listFiles((dir, name) -> name.endsWith(".json"));

        if (jsonFiles != null) {
            ObjectMapper objectMapper = new ObjectMapper();

            for (File jsonFile : jsonFiles) {
                try {
                    ArrayNode jsonArray = (ArrayNode) objectMapper.readTree(jsonFile);

                    for (JsonNode node : jsonArray) {
                        String packageName = node.path("name").asText();
                        if (!packageName.isEmpty()) {
                            packageName += "." + mavenPropertiesTag;
                            ((ObjectNode) node).put("name", packageName);
                        }
                    }

                    consolidatedArray.addAll(jsonArray);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else {
            System.out.println("No JSON files found in the project folder.");
        }

        return consolidatedArray;
    }

    private static void writeConsolidatedJsonToFile(ArrayNode consolidatedArray, String mavenPropertiesTag) {
        try {
            String filename = "./target/consolidated-" + mavenPropertiesTag + ".json";
            new ObjectMapper().writeValue(new File(filename), consolidatedArray);
            System.out.println("Consolidated JSON array file created successfully: " + filename);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
