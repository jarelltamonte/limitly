// Import Sample Data to New Firebase Project
// This script imports sample data to your new Firebase project

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Configuration - Update with your new project details
const NEW_PROJECT_ID = 'limitly-new'; // Your new project ID

// Initialize Firebase Admin SDK for new project
const app = admin.initializeApp({
  projectId: NEW_PROJECT_ID,
  // Use service account key file
  credential: admin.credential.cert('./new-project-key.json'),
}, 'new');

const db = app.firestore();

// Path to sample data file
const sampleDataPath = path.join(__dirname, 'sample_data.json');

async function importCollection(collectionName, documents) {
  console.log(`📥 Importing collection: ${collectionName}`);
  
  try {
    if (!Array.isArray(documents) || documents.length === 0) {
      console.log(`⚠️  No documents found for ${collectionName}`);
      return 0;
    }
    
    console.log(`📄 Found ${documents.length} documents for ${collectionName}`);
    
    // Import documents in batches
    const batchSize = 500; // Firestore batch limit
    let importedCount = 0;
    
    for (let i = 0; i < documents.length; i += batchSize) {
      const batch = db.batch();
      const batchDocs = documents.slice(i, i + batchSize);
      
      batchDocs.forEach((doc) => {
        const docRef = db.collection(collectionName).doc(doc.id);
        batch.set(docRef, doc);
      });
      
      await batch.commit();
      importedCount += batchDocs.length;
      
      console.log(`  📦 Imported batch ${Math.floor(i / batchSize) + 1}: ${batchDocs.length} documents`);
    }
    
    console.log(`✅ Successfully imported ${importedCount} documents to ${collectionName}`);
    return importedCount;
    
  } catch (error) {
    console.error(`❌ Error importing ${collectionName}:`, error);
    return 0;
  }
}

async function importSampleData() {
  console.log('🚀 Starting sample data import...');
  console.log(`🏢 Target project: ${NEW_PROJECT_ID}`);
  
  // Check if sample data file exists
  if (!fs.existsSync(sampleDataPath)) {
    console.error(`❌ Sample data file not found: ${sampleDataPath}`);
    return;
  }
  
  // Read sample data file
  const fileContent = fs.readFileSync(sampleDataPath, 'utf8');
  const sampleData = JSON.parse(fileContent);
  
  console.log(`📄 Loaded sample data with ${Object.keys(sampleData).length} collections`);
  
  const importResults = {};
  let totalImported = 0;
  
  // Import each collection
  for (const [collectionName, documents] of Object.entries(sampleData)) {
    const count = await importCollection(collectionName, documents);
    importResults[collectionName] = count;
    totalImported += count;
  }
  
  console.log('\n📊 Import Summary:');
  console.log(`🏢 Target Project: ${NEW_PROJECT_ID}`);
  console.log(`📦 Total Documents Imported: ${totalImported}`);
  console.log('\n📋 Collections Imported:');
  Object.entries(importResults).forEach(([collection, count]) => {
    console.log(`  ${collection}: ${count} documents`);
  });
  
  console.log(`\n✅ Sample data import completed!`);
  console.log(`🔗 Check your Firebase Console: https://console.firebase.google.com/project/${NEW_PROJECT_ID}`);
  
  // Clean up
  await app.delete();
}

// Run import
importSampleData().catch(console.error);

// Instructions for using this script:
/*
1. Make sure you have the new project service account key:
   - new-project-key.json in this directory

2. Run the script:
   node import_sample_data.js

3. Verify the data in your new Firebase project

4. Update your Flutter app configuration to use the new project
*/ 