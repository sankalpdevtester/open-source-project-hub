import React, { useState } from 'react';
import axios from 'axios';

function ProjectForm() {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [url, setUrl] = useState('');
  const [errors, setErrors] = useState({});

  const handleSubmit = (event) => {
    event.preventDefault();
    axios.post('/projects', {
      project: {
        name,
        description,
        url,
      },
    })
      .then((response) => {
        console.log(response.data);
        setName('');
        setDescription('');
        setUrl('');
      })
      .catch((error) => {
        setErrors(error.response.data);
      });
  };

  return (
    <form onSubmit={handleSubmit}>
      <div className="form-group">
        <label>Name:</label>
        <input type="text" className="form-control" value={name} onChange={(event) => setName(event.target.value)} />
        {errors.name && <div className="text-danger">{errors.name}</div>}
      </div>
      <div className="form-group">
        <label>Description:</label>
        <textarea className="form-control" value={description} onChange={(event) => setDescription(event.target.value)} />
        {errors.description && <div className="text-danger">{errors.description}</div>}
      </div>
      <div className="form-group">
        <label>URL:</label>
        <input type="text" className="form-control" value={url} onChange={(event) => setUrl(event.target.value)} />
        {errors.url && <div className="text-danger">{errors.url}</div>}
      </div>
      <button type="submit" className="btn btn-primary">Submit</button>
    </form>
  );
}

export default ProjectForm;