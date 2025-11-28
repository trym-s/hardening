import { Routes, Route } from 'react-router-dom';
import { HomePage } from './pages/HomePage';
import { OsSelectionPage } from './pages/OsSelectionPage';

function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/os" element={<OsSelectionPage />} />
    </Routes>
  );
}

export default App;
